# Wire the Flutter app to the AraContract Analyzer backend

**Status:** Approved (pending user spec review)
**Date:** 2026-08-15
**Scope:** `app_v1` (Flutter). The backend (`AraContract_Analyzer`) is **not** modified.

## 1. Goal

The Flutter app (`app_v1`) is currently a UI shell: every screen renders hardcoded mock
data, there is no networking code (no HTTP client in `pubspec.yaml`), and `upload_document_screen`
literally simulates upload with a `Future.delayed` loop. This spec defines how to connect
the app to the real AraContract Analyzer API (`http://localhost:8000`, see `API_DOCUMENTATION.md`)
so the existing screens perform real contract analysis, comparison, and RAG chat, with
analyses persisted locally for History and the Dashboard.

## 2. Decisions (locked)

| Decision | Choice |
|---|---|
| Scope | **Core + local History.** Upload→Analyze→Results, Compare two contracts, RAG Chat, plus local on-device persistence feeding History + Dashboard. Granular endpoints (`/upload`, `/segment*`, `/classify*`, `/summarize`, `/rag/summarize`) are **not** exposed; the bundled `/analyze` is the entry point. |
| Run target | **Physical Android device** on the same Wi-Fi as the host running the backend. |
| Backend URL | **Settings-configurable** (`http://<host-lan-ip>:8000`), persisted in `SharedPreferences`, default `http://10.17.81.209:8000` (host's current `wlo1` LAN IP). `0.0.0.0` is the server bind host, not a connectable client address. |
| Auth gate | **Keep** the existing Firebase/Google sign-in gate in `app_wrapper.dart` + `auth_screen.dart`. API auth is disabled, so backend calls happen after sign-in. |
| Data/state architecture | **BLoC + repositories + dio.** Matches the existing `bloc/` convention; network IO kept out of widgets. |
| Languages | **Arabic + English** via the existing `.arb` l10n system. App *chrome* is bilingual; API *content* (summary, clause text, display names) is Arabic in both locales. |
| Dark mode | **Real support.** Route neutral colors through `Theme.of(context).colorScheme`; semantic risk colors stay static. Bounded to rewired screens + the shared widgets they use. |

## 3. Architecture

```
lib/
├─ config/api_config.dart         # default base url const + prefs key
├─ models/analysis_models.dart    # AnalyzedClause, AnalysisResult, AnalysisStats,
│                                 # ComparisonResult, ContractSummary, ContractDifference,
│                                 # RagIngestResponse, RetrievedClause, RagAnswer,
│                                 # ChatMessage, HistoryEntry
├─ services/
│  ├─ api_client.dart             # Dio wrapper; reads baseUrl from SharedPreferences at request time
│  ├─ backend_repository.dart     # 5 typed methods over ApiClient → models, throws ApiException
│  └─ history_store.dart          # local list() / get(id) / save(result) / delete(id) in SharedPreferences
├─ bloc/
│  ├─ analysis/                   # AnalysisBloc  (upload→/analyze→results)
│  ├─ comparison/                 # ComparisonBloc (/compare)
│  ├─ chat/                       # ChatBloc (RAG ingest→ask→delete session)
│  ├─ history/                    # HistoryBloc (local list/delete)
│  └─ language/, theme/           # unchanged
└─ (existing widgets/, screens/, routes/ updated in place)
```

Each feature BLoC follows the existing 3-file `part` convention (the `language/` trio is the
template): `X_bloc.dart` + `X_event.dart` + `X_state.dart` in one directory, Equatable events/states,
`part of` directives linking them.

**Cross-cutting data flow:**
- `AnalysisBloc` calls `BackendRepository.analyze(file, onProgress)`, gets a typed
  `AnalysisResult`, calls `HistoryStore.save(...)` (local), emits the result. The Results
  screen reads the BLoC's current success state; History reads the same stored result by id.
- `ChatBloc` is keyed off a chosen analysis's clause texts → `ragIngest` (stores `session_id`) →
  `ragAsk` per message → `ragDeleteSession` on close.
- The backend base URL lives in Settings → persisted → `ApiClient` reads it at request time
  (no app restart to apply a change). No BLoC for this single persisted string.

## 4. Typed models

Plain Dart classes with `fromJson` factories; fields the UI binds to only. Nullable where the
API tolerates absence. All in `lib/models/analysis_models.dart`.

```dart
class AnalyzedClause {                 // shape shared by /analyze + /rag/summarize
  final String text;
  final String predictedTypeClause;    // "termination", ...
  final String typeDisplayName;        // "فسخ / إنهاء"
  final String predictedRiskLevel;     // "low"|"medium"|"high"
  final String riskDisplayName;        // "مرتفع"
  final String warning;                // "" if none
}

class AnalysisStats {
  final int totalClauses;
  final int highRiskClauses;
  final int mediumRiskClauses;
  final int lowRiskClauses;
  final Map<String, int> typeDistribution;
}

class AnalysisResult {
  final String filename;
  final bool isScanned;
  final List<AnalyzedClause> clauses;
  final String summary;            // Arabic executive summary
  final AnalysisStats stats;
  // toJson() for HistoryStore round-trip
}

class ContractSummary {                 // one per contract in /compare
  final String filename;
  final int totalClauses, highRiskClauses, mediumRiskClauses, lowRiskClauses;
  final Map<String, int> typeDistribution;
}

class ContractDifference {
  final String type;                    // "risk_level"|"clause_type"|"missing_clause"...
  final String description;
  final dynamic contract1Value;
  final dynamic contract2Value;
}

class ComparisonResult {
  final ContractSummary contract1Summary;
  final ContractSummary contract2Summary;
  final List<ContractDifference> differences;
}

class RagIngestResponse { final String sessionId; final int clausesCount; }
class RetrievedClause { final int clauseIndex; final String parentText; final double score; }
class RagAnswer { final String answer; final List<RetrievedClause> retrievedClauses; final String sessionId; }

class ChatMessage {                     // chat-domain, used by ChatBloc; not an API type
  final String text;                    // user question or assistant answer
  final bool isUser;                    // true = user, false = assistant
  final List<RetrievedClause> sources;  // empty for user turns; populated for assistant turns
  final DateTime sentAt;               // assigned locally (clock), not from the API
  // not serialized — chat is session-only, discarded on ChatClosed
}

class HistoryEntry {                    // local wrapper, not an API type
  final String id;                      // uuid at save time
  final DateTime savedAt;              // assigned at save time
  final AnalysisResult result;
  // toJson()/fromJson() persisted by HistoryStore
}
```

**Deliberately not modeled:** `type_clause_probabilities` / `risk_level_probabilities` from
`/classify` and `/classify/batch`. Those endpoints are out of scope (we use the bundled
`/analyze`, which does not return probability maps). No clause-type-risk enum layer; the UI
renders the API's `*DisplayName` strings directly and reads `.entries` of `typeDistribution`
where aggregation is needed.

## 5. API client & base URL config

**`lib/config/api_config.dart`**
```dart
// Default connectable address for a physical Android device on the same Wi-Fi
// as the host running the backend. 0.0.0.0 is the SERVER's bind host, not a
// connectable client address — do not use it as baseUrl.
// Users edit this at runtime in Profile & Settings → Backend URL.
const String kDefaultApiBaseUrl = 'http://10.17.81.209:8000';
const String kApiBaseUrlPrefKey = 'api_base_url';
```

**`lib/services/api_client.dart`** — thin Dio wrapper, injectable for tests:
- Reads base URL from `SharedPreferences` at request time (default `kDefaultApiBaseUrl`,
  falls back if unset/empty/unparseable). Sets `dio.options.baseUrl`.
- Methods: `get<T>(path)`, `postJson<T>(path, body)`, `postMultipart<T>(path, {field, extra,
  onProgress})`. `onProgress(int sent, int total)` drives the multipart send-progress bar.
- One Dio interceptor normalizes failures into a single `ApiException` carrying a `message`:
  the API `ErrorResponse.message` when present, the `details` on 422, or the transport message
  for timeout/unreachable. Feature BLoCs map `ApiException.message` to a user-facing string;
  no widget opens a try/catch on Dio types.
- No auth header (API auth disabled).
- **Timeouts:** connect 30s (an unreachable backend on a phone is a likely state — surface it
  fast), send 50s (accommodate `/analyze` upload + OCR + LLM summary on large PDFs; end-to-end
  pipeline runs can take 10–40s).

**`lib/services/backend_repository.dart`** — typed methods over `ApiClient`, returns models,
throws `ApiException`. Exactly 5 methods (the endpoints in scope):

```dart
Future<AnalysisResult> analyze(PlatformFile file, {void Function(int,int)? onProgress});
Future<ComparisonResult> compare(PlatformFile file1, PlatformFile file2);
Future<RagIngestResponse> ragIngest(List<String> clauses);
Future<RagAnswer> ragAsk(String sessionId, String question, {int topK = 3});
Future<void> ragDeleteSession(String sessionId);
```

`analyze` and `compare` use multipart (file upload). On physical Android, `PlatformFile.path`
is a real filesystem path → `MultipartFile.fromFile`. (Web/desktop targets not in this scope;
a `fromBytes` fallback is deferred until those targets are added.) `ragIngest`/`ragAsk`/`ragDeleteSession`
are JSON. Paths prefix `/api/contract` per the docs.

## 6. Local history store

**`lib/services/history_store.dart`** — one JSON list under a single `SharedPreferences` key.

```dart
class HistoryStore {
  static const _key = 'analysis_history';
  Future<List<HistoryEntry>> list();        // newest first
  Future<HistoryEntry?> get(String id);
  Future<HistoryEntry> save(AnalysisResult r);  // assigns uuid + savedAt, prepends, caps at 20
  Future<void> delete(String id);
  Future<void> clear();
}
```

- `save` is called from `AnalysisBloc` immediately after a successful `/analyze`, so every
  analysis is automatically in history. No separate save action.
- **Soft cap: 20 entries** (drop oldest beyond 20). Per-entry size is not bounded beyond the
  API's 20MB upload limit; this is acceptable for v1. If it proves heavy, move to `sqflite`
  later — deferred (YAGNI).
- No schema-version field for v1; bump a `schema` int only if the model shape changes.
- `HistoryStore` is the only local provider for both `HistoryScreen` (full list) and the
  Dashboard (top 3).

## 7. Feature BLoCs

New for the app: a loading/error/success state pattern, used idiomatically.

**AnalysisBloc** — spans Upload→Results (app-scoped so Results reads the result post-navigation):
```
Events:  AnalyzeRequested(PlatformFile file) | CancelRequested
States:  AnalysisInitial | AnalysisLoading(double progress)   // 0..1
         AnalysisError(String message) | AnalysisSuccess(AnalysisResult result)
Flow:   AnalyzeRequested → repo.analyze(file, onProgress: p => emit Loading(p))
        → HistoryStore.save(result) → emit Success(result)
        → on ApiException emit Error(message)
```
`AnalysisLoading(progress)` carries multipart *send* progress to the existing
`LinearProgressIndicator`. Send-progress ≠ pipeline-progress: once uploaded, the bar sits at
~95% with an "Analyzing…" label while OCR+classify+LLM run server-side — no fabricated motion.

**ComparisonBloc**:
```
Events:  CompareRequested(PlatformFile file1, PlatformFile file2)
States:  ComparisonInitial | ComparisonLoading | ComparisonError(msg) | ComparisonSuccess(ComparisonResult)
```
No percentage bar: `/compare` is a single two-file multipart; render an indeterminate
`CircularProgressIndicator` (a 0–100% bar would mis-represent upload-fraction-of-two-files).

**ChatBloc** — RAG lifecycle, keyed off a chosen analysis:
```
Events:  ChatStarted(List<String> clauses) | QuestionSubmitted(String question) | ChatClosed
States:  ChatInitial | ChatIngesting | ChatReady | ChatAnswering | ChatError(msg)
         (each non-initial state carries List<ChatMessage> = user+assistant turns)
Flow:   ChatStarted → repo.ragIngest(clauses) → store sessionId → ChatReady([])
        QuestionSubmitted → append user msg → ChatAnswering → repo.ragAsk(sessionId, q)
        → append assistant msg (with retrieved sources) → ChatReady
        ChatClosed → repo.ragDeleteSession(sessionId)  // best-effort, errors ignored
```
`session_id` lives in the BLoC, never the UI. Chat is reached from the Dashboard "Start AI Chat"
quick action → choose a recent analysis from history (or "Analyze a contract first" empty state
if history empty) → start the BLoC with that contract's clause texts.

**HistoryBloc** — local only:
```
Events:  HistoryLoadRequested | HistoryDeleteRequested(String id)
States:  HistoryInitial | HistoryLoading | HistoryLoaded(List<HistoryEntry>) | HistoryError(msg)
```
Pure local; the error state exists for parity/safety.

**Provisioning:** add the four new BLoCs as `BlocProvider`s in `App()`'s existing
`MultiBlocProvider` (same shape, 4 more providers). App-scoped provision is the correct choice
because `pushNamed` routing doesn't carry providers. This is the one material edit to `app.dart`.
New BLoC constructors do nothing until an event fires, so creating them at app start is cheap.
No settings BLoC for the base URL (single persisted string).

## 8. Screen set: removals and consolidation

The `ar_*` duplicates existed only because there was no proper l10n; with bilingual l10n live,
they are folded into the single flow.

**Files deleted (5):**
- `lib/screens/ar_dashboard_screen.dart`
- `lib/screens/ar_operations_log_screen.dart`
- `lib/screens/ar_clause_details_screen.dart`
- `lib/screens/ar_contract_comparison_screen.dart`
- `lib/screens/screen_gallery.dart`

**Routes removed from `app_routes.dart`:** `arDashboard`, `arOperationsLog`, `arClauseDetails`,
`arContractComparison`, and `home` (the gallery route). Nothing in the codebase navigates to
`AppRoutes.home` (`/`), and `App()` uses `initialRoute: homeDashboard`, so removing the `home`
entry leaves no dangling route — no repointing needed. Remove the `ScreenGallery` import line.

The "Operations Log" notion drops entirely (was showcase-only, no supported flow). `auth_screen`
and `onboarding_screen` are untouched.

**Surviving + rewired screens:** `upload_document_screen`, `analysis_results_screen`,
`clause_details_screen`, `contract_comparison_screen`, `ai_chat_screen`, `history_screen`,
`home_dashboard_screen`, `profile_settings_screen` (gains a Backend URL tile).

## 9. Screen-by-screen wiring

Content flagged for **removal** (fabricated, no API basis) vs **population**.

**`upload_document_screen.dart`** (stays StatefulWidget + AnalysisBloc via BlocConsumer)
- Replace the simulated `Future.delayed` loop with `AnalyzeRequested(file)`. Map
  `AnalysisLoading(progress)` → existing `LinearProgressIndicator`; `AnalysisSuccess` →
  `Navigator.pushReplacementNamed(analysisResults)`; `AnalysisError(msg)` → SnackBar + reset.
- **Guard fix:** bump local `maxSizeBytes` 10MB → **20MB** to match backend `MAX_FILE_SIZE`.
- **Guard fix:** restrict picker to `FileType.custom` with allowed extensions
  `.pdf .png .jpg .jpeg .tiff .bmp` (backend rejects others, incl. DOCX). Fix the misleading
  "any file type" text.

**`analysis_results_screen.dart`** (stays StatelessWidget, reads AnalysisBloc success state)
- **Remove** the fabricated "Summary Score" block (Overall Compliance 82% / Critical Issues 2 /
  Negotiable 7 — no compliance % in the API). **Replace** with `stats`: total/high/medium/low
  counts as `MetricTile`s.
- Show the Arabic `summary` in a card at top.
- **Replace** the `_findings` const + `_nextSteps` const with real `clauses`: each
  `AnalyzedClause` as an `AppCard` (type chip + risk chip + text + warning if non-empty). Tap →
  `clauseDetails` seeded with that clause.
- Download icon stays, empty/disabled for v1 (export out of scope).
- Fallback "no analysis yet" if state is not `Success` (e.g. deep-linked).

**`clause_details_screen.dart`** (StatelessWidget, seeded via route with an `AnalyzedClause`)
- **Delete** the fabricated `_recommendations` (`reduce liability cap`, etc. — no field in API).
- Render clause text + `typeDisplayName` chip + `riskDisplayName` chip + `warning` only.

**`contract_comparison_screen.dart`** (StatelessWidget → StatefulWidget + ComparisonBloc)
- Two file pickers (adapt `_DropZone`) + Compare button.
- Render `ComparisonResult`: two contract cards from `contract1/2Summary` (filename + counts,
  replacing "Master Services Agreement v2.2/3.0"); `differences[]` as cards (`difference.type`
  chip label, `description` as title/detail).
- **Remove** the hardcoded "AI Summary" card — `/compare` returns no summary text.

**`ai_chat_screen.dart`** (StatelessWidget → StatefulWidget + ChatBloc)
- `initState`: `ChatStarted(clauses)` (clauses from a passed `HistoryEntry` or current
  `AnalysisResult`).
- Replace static demo bubbles with real turns. Send button disabled while `ChatAnswering`;
  assistant bubbles show the answer + expandable `RetrievedClause` source chips (small new
  widget reusing `ChatBubble`).
- "Analyze a contract first" empty state when history empty. `ChatClosed` on dispose.

**`history_screen.dart`** (StatelessWidget → StatefulWidget + HistoryBloc)
- Replace the `_items` const with `BlocBuilder<HistoryBloc>` over `HistoryEntry`. Row:
  filename, risk tag (high>0→High else medium>0→Medium else Low), clause count, formatted
  `savedAt`. Tap → results view of that stored result. Delete → `HistoryDeleteRequested`.
  Empty state when zero.

**`home_dashboard_screen.dart`** (surgical)
- **"Recent Analyses":** top 3 from `HistoryStore.list()` (filename + summary snippet + risk
  tag), replacing the `_recentAnalyses` const.
- **"Overview" stat cards:** real numbers — active reviews = `history.length`; risk alerts =
  `sum(stats.highRiskClauses)` across history. **Drop the fabricated trend strings**
  ("+4 since yesterday", "2 high priority") — show no trend, or a neutral subtitle.
- **Quick Actions chips:** wire Upload / Compare / Start AI Chat to their routes (were no-ops).
  Disable the "Export Report" chip with a v1-unavailable tooltip (export out of scope).
- Keep `_AnalyzeContractCard`, header/avatar semantics. No pull-to-refresh, no live monitoring.

**`profile_settings_screen.dart`** (additive)
- One new `SettingTile` "Backend URL" under the Workspace card. Tap → dialog with a `TextField`
  prefilled from `SharedPreferences[kApiBaseUrlPrefKey]` (default `kDefaultApiBaseUrl`);
  save writes to SP. `ApiClient` picks it up on next request. No BLoC. Existing lang/theme/
  other tiles untouched.

## 10. Arabic + English (i18n)

The system is live: `generate: true`, matching `lib/l10n/app_en.arb` + `app_ar.arb`,
`LanguageBloc` switches locale live, Settings already has an English↔Arabic toggle.

- Treat the rewired screens for user-facing **chrome** (titles, headers, button labels,
  SnackBars, error strings, empty states). Add each as a key to **both** `.arb`s. Reuse existing
  keys where present (`history`, `upload`, `profile`, …).
- Foreseeable new keys: `analysisResults`, `summary`, `clauses`, `riskTagHigh/Medium/Low`,
  `compareContracts`, `sideBySideView`, `diffHighlights`, `typeAQuestion`, `analyzeButton`,
  `analyzing`, `backendUrl`, `noAnalysesYet`, `analyzeContractFirst`, `sources`, and others
  surfaced during implementation.
- Rule: **no new hardcoded user-facing strings** in touched code; every chrome string via
  `AppLocalizations.of(context)`. (Route keys, asset names, log text exempt.)
- **API content stays Arabic in both locales** (summary, clause text, display names) — the
  contract is Arabic. English content outputs would be a backend change, out of scope.
- **RTL:** Flutter flips layout from the `ar` locale automatically. Audit touched screens for
  hardcoded `TextDirection.ltr`; use `EdgeInsetsDirectional`/`Align` where a direction affects
  Arabic. Scope-bounded to touched screens, not a whole-app RTL sweep.

## 11. Dark mode (real support)

`ThemeBloc` already toggles `ThemeMode`; `AppTheme.dark()` builds a proper dark `ColorScheme`.
The current breakage: screens/widgets reach for **static light** `AppColors.*` neutrals
directly (e.g. `AppCard` uses `AppColors.surface` = white even in dark mode).

Fix, scope-bounded to rewired screens + the shared widgets they use:
- **Neutrals** (`background`, `surface`, `surfaceVariant`, `outline`, `onSurface`) → read from
  `Theme.of(context).colorScheme` (`colorScheme.surface`, `colorScheme.outlineVariant`,
  `colorScheme.onSurface`). These flip under the existing dark theme automatically.
- **Semantic risk colors stay static** `AppColors.riskHigh/Medium/Low` — high/medium/low look
  identical in both modes.
- **Shared widgets threaded through Theme as part of this work:** `AppCard`, `AppSectionHeader`,
  `ChatBubble`, `MetricTile`, `StatCard`, `SettingTile`, `AppBottomNavigation`, `TagChip`.
  Neutral colors → `colorScheme`.
- **Not done:** refactor `AppColors` into context-aware getters (whole-app change, violates
  surgical scope); touch deleted/untouched screens (`ar_*` are deleted; out-of-flow screens
  keep light-only behavior).

## 12. Android platform config (physical device, cleartext)

The backend is plain `http://` on a LAN IP; Android blocks cleartext by default. Required,
one-time:
- `android/app/src/main/AndroidManifest.xml`: add `<uses-permission android:name="android.permission.INTERNET"/>`
  and `android:usesCleartextTraffic="true"` on the `<application>` tag (or a targeted
  `network_security_config.xml` permitting the backend host, scoped narrowly).
- Phone and host must be on the same Wi-Fi; the host backend bound `0.0.0.0:8000` must be
  running.

## 13. Out of scope (explicit)

- Wrapping `/`, `/health`, `/rag/health`, `/upload`, `/segment`, `/segment/file`, `/classify`,
  `/classify/batch`, `/summarize`, `/rag/summarize` (all building-block endpoints; `/analyze`
  bundles the analysis pipeline).
- Export / report download (Results + Dashboard Export chip disabled for v1).
- A backend history endpoint (none exists; persistence is local-only).
- Migrating local storage to `sqflite` (deferred unless entry size proves heavy).
- `web`/`desktop` targets and the `fromBytes` upload fallback.
- English contract content outputs (backend change).
- Refactoring `AppColors` globally or a whole-app RTL sweep.
- Changing the Firebase auth gate.

## 14. Testing

- Models: `fromJson` unit tests for each response shape (incl. nullable/absent fields).
- `HistoryStore`: save → list → get → delete round-trip + the 20-entry cap.
- `BackendRepository`: against a stub `ApiClient` (asserts correct paths, multipart fields,
  JSON bodies, return-type mapping) — no real network.
- BLoCs: `blocTest` for the loading/error/success transitions (inject a stub repository).
- Widget tests for the rewired screens' loading/error/empty states (stub BLoC).
- The shared-widget neutral-color threading gets light widget tests asserting the dark-theme
  branch renders `colorScheme.surface` (not the static light `AppColors.surface`).

## 15. Risks / open items

- **`PlatformFile.path` on physical Android:** expected to be a real path → `fromFile`.
  Verify at implementation start; otherwise fall back to `fromBytes(file.bytes)`.
- **Base URL drift:** the default LAN IP changes across networks; the Settings tile mitigates
  this without a rebuild. Users must know to edit it on a new network.
- **50s send timeout** is a judgment call for large scanned PDFs through OCR+LLM; revisit if
  real analyze runs time out.
- The HTTP spec, lowercase clause-type/risk keys match the docs; if the backend evolves keys,
  `fromJson` breaks loudly (desired) rather than silently.

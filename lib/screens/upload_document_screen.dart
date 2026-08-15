import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/analysis/analysis_bloc.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/bottom_navigation.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  static const int maxSizeBytes = 10 * 1024 * 1024; // 10 MB

  PlatformFile? _selected;
  String? _error;

  Future<void> _pick() async {
    setState(() {
      _error = null;
      _selected = null;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (!mounted || result == null) return;

    final file = result.files.single;
    if (file.size > maxSizeBytes) {
      setState(() {
        _selected = null;
        _error =
            'File is ${_formatSize(file.size)}, which exceeds the 10 MB limit.';
      });
      return;
    }

    setState(() => _selected = file);
  }

  void _analyze() {
    if (_selected == null) return;
    context.read<AnalysisBloc>().add(AnalyzeRequested(_selected!));
  }

  @override
  Widget build(BuildContext context) {
    final file = _selected;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.upload),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AnalysisBloc, AnalysisState>(
        listener: (context, state) {
          if (state is AnalysisSuccess) {
            Navigator.of(context).pushNamed(
              '/analysis-results',
              arguments: state.result,
            );
          } else if (state is AnalysisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.riskHigh,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppSectionHeader(
              title: l10n.newUpload,
              subtitle: l10n.documentsAndPhotos,
            ),
            const SizedBox(height: 12),
            _DropZone(
              file: file,
              error: _error,
              onTap: _pick,
              l10n: l10n,
            ),
            const SizedBox(height: 16),
            if (file != null) ...[
              AppCard(
                child: BlocBuilder<AnalysisBloc, AnalysisState>(
                  builder: (context, state) {
                    final isLoading = state is AnalysisLoading;
                    final progress = isLoading ? (state.progress * 100).toStringAsFixed(0) : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.description_outlined,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_formatSize(file.size)} • ${file.extension ?? "file"} • '
                                    '${_formatMime(file)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remove',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: isLoading
                                  ? null
                                  : () => setState(() => _selected = null),
                            ),
                          ],
                        ),
                        if (isLoading) ...[
                          const SizedBox(height: 12),
                          LinearProgressIndicator(value: state.progress),
                          const SizedBox(height: 6),
                          Text(
                            '$l10n.analyzing $progress%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _analyze,
                icon: const Icon(Icons.analytics_outlined),
                label: Text(l10n.analyzeButton),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Any file type is supported (PDF, DOCX, images, scans, etc.). Files larger '
              'than 10 MB are rejected before upload starts.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  static String _formatMime(PlatformFile file) {
    final bytes = file.bytes;
    if (bytes == null || bytes.length < 4) return 'unknown';
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'image/jpeg';
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      return 'image/gif';
    }
    if (bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return 'application/pdf';
    }
    return 'binary';
  }
}

class _DropZone extends StatelessWidget {
  final PlatformFile? file;
  final String? error;
  final VoidCallback? onTap;
  final AppLocalizations l10n;

  const _DropZone({
    required this.file,
    required this.error,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    final hasError = error != null;
    final colorScheme = Theme.of(context).colorScheme;

    final accent = hasError ? AppColors.riskHigh : AppColors.secondary;
    final borderColor = hasError ? AppColors.riskHigh : (hasFile ? AppColors.secondary : colorScheme.surfaceContainerHighest);
    final bg = hasError
        ? AppColors.riskHigh.withValues(alpha: 0.06)
        : (hasFile ? AppColors.secondary.withValues(alpha: 0.04) : colorScheme.surface);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: hasFile || hasError ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasError
                    ? Icons.error_outline_rounded
                    : (hasFile ? Icons.check_circle_outline_rounded : Icons.upload_file_rounded),
                color: accent,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              hasError
                  ? l10n.fileTooLarge
                  : (hasFile ? l10n.readyToUpload : l10n.tapToChooseFile),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              hasError
                  ? error!
                  : 'Documents, scans, photos — any format, max 10 MB',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
            if (!hasFile && !hasError) ...[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: onTap,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.browseFiles),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

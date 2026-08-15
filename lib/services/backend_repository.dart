import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'api_client.dart';
import '../models/analysis_models.dart';

class BackendRepository {
  final ApiClient _api;

  BackendRepository(this._api);

  Future<AnalysisResult> analyze(
    PlatformFile file, {
    void Function(int, int)? onProgress,
  }) async {
    return _api.postMultipart<AnalysisResult>(
      '/api/contract/analyze',
      field: 'file',
      file: file,
      onProgress: onProgress,
      decoder: AnalysisResult.fromJson,
    );
  }

  Future<ComparisonResult> compare(
    PlatformFile file1,
    PlatformFile file2,
  ) async {
    const path = '/api/contract/compare';

    final formData = FormData.fromMap({
      'file1': await MultipartFile.fromFile(file1.path!),
      'file2': await MultipartFile.fromFile(file2.path!),
    });

    final response = await _api.postMultipartRaw<ComparisonResult>(
      path,
      formData: formData,
      decoder: ComparisonResult.fromJson,
    );

    return response;
  }

  Future<RagIngestResponse> ragIngest(List<String> clauses) async {
    return _api.postJson<RagIngestResponse>(
      '/api/contract/rag/ingest',
      body: {'clauses': clauses},
      decoder: RagIngestResponse.fromJson,
    );
  }

  Future<RagAnswer> ragAsk(
    String sessionId,
    String question, {
    int topK = 3,
  }) async {
    return _api.postJson<RagAnswer>(
      '/api/contract/rag/ask',
      body: {
        'session_id': sessionId,
        'question': question,
        'top_k': topK,
      },
      decoder: RagAnswer.fromJson,
    );
  }

  Future<void> ragDeleteSession(String sessionId) async {
    await _api.delete('/api/contract/rag/session/$sessionId');
  }
}
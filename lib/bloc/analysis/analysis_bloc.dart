import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../../services/backend_repository.dart';
import '../../../services/history_store.dart';
import '../../../services/api_client.dart'; // for ApiException
import '../../../models/analysis_models.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final BackendRepository _repo;
  final HistoryStore _history;

  AnalysisBloc({required BackendRepository repo, required HistoryStore history})
      : _repo = repo,
        _history = history,
        super(const AnalysisInitial()) {
    on<AnalyzeRequested>(_onAnalyzeRequested);
    on<CancelRequested>(_onCancelRequested);
  }

  Future<void> _onAnalyzeRequested(
    AnalyzeRequested event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(const AnalysisLoading(0.0));
    try {
      final result = await _repo.analyze(
        event.file,
        onProgress: (sent, total) {
          if (total > 0) emit(AnalysisLoading(sent / total));
        },
      );
      await _history.save(result);
      emit(AnalysisSuccess(result));
    } on ApiException catch (e) {
      emit(AnalysisError(e.message));
    }
  }

  void _onCancelRequested(
    CancelRequested event,
    Emitter<AnalysisState> emit,
  ) {
    emit(const AnalysisError('Cancelled'));
  }
}
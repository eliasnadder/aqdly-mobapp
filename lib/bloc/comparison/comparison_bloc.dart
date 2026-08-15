import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../../services/backend_repository.dart';
import '../../../services/api_client.dart'; // for ApiException
import '../../../models/analysis_models.dart';

part 'comparison_event.dart';
part 'comparison_state.dart';

class ComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  final BackendRepository _repo;

  ComparisonBloc({required BackendRepository repo})
      : _repo = repo,
        super(const ComparisonInitial()) {
    on<CompareRequested>(_onCompareRequested);
  }

  Future<void> _onCompareRequested(
    CompareRequested event,
    Emitter<ComparisonState> emit,
  ) async {
    emit(const ComparisonLoading());
    try {
      final result = await _repo.compare(event.file1, event.file2);
      emit(ComparisonSuccess(result));
    } on ApiException catch (e) {
      emit(ComparisonError(e.message));
    }
  }
}
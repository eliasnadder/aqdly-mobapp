import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/analysis_models.dart';
import '../../../services/history_store.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryStore _store;

  HistoryBloc({required HistoryStore store})
      : _store = store, super(HistoryInitial()) {
    on<HistoryLoadRequested>(_onLoadRequested);
    on<HistoryDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
      HistoryLoadRequested event, Emitter<HistoryState> emit) async {
    emit(const HistoryLoading());
    try {
      final entries = await _store.list();
      emit(HistoryLoaded(entries));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
      HistoryDeleteRequested event, Emitter<HistoryState> emit) async {
    try {
      await _store.delete(event.id);
      if (state is HistoryLoaded) {
        final current = (state as HistoryLoaded).entries;
        emit(HistoryLoaded(current.where((e) => e.id != event.id).toList()));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
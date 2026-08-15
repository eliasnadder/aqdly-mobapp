import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/backend_repository.dart';
import '../../../services/api_client.dart'; // for ApiException
import '../../../models/analysis_models.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final BackendRepository _repo;
  String? _sessionId;

  ChatBloc({required BackendRepository repo})
      : _repo = repo,
        super(const ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<QuestionSubmitted>(_onQuestionSubmitted);
    on<ChatClosed>(_onChatClosed);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatIngesting([]));
    try {
      final ingestResponse = await _repo.ragIngest(event.clauses);
      _sessionId = ingestResponse.sessionId;
      emit(const ChatReady([]));
    } on ApiException catch (e) {
      emit(ChatError(e.message, []));
    }
  }

  Future<void> _onQuestionSubmitted(
    QuestionSubmitted event,
    Emitter<ChatState> emit,
  ) async {
    final currentMessages = state is ChatReady
        ? (state as ChatReady).messages
        : state is ChatAnswering
            ? (state as ChatAnswering).messages
            : state is ChatIngesting
                ? (state as ChatIngesting).messages
                : <ChatMessage>[];

    final userMsg = ChatMessage(
      text: event.question,
      isUser: true,
      sources: [],
      sentAt: DateTime.now(),
    );
    emit(ChatAnswering([...currentMessages, userMsg]));

    try {
      final answer = await _repo.ragAsk(_sessionId!, event.question);
      final assistantMsg = ChatMessage(
        text: answer.answer,
        isUser: false,
        sources: answer.retrievedClauses,
        sentAt: DateTime.now(),
      );
      emit(ChatReady([...currentMessages, userMsg, assistantMsg]));
    } on ApiException catch (e) {
      emit(ChatError(e.message, currentMessages));
    }
  }

  Future<void> _onChatClosed(
    ChatClosed event,
    Emitter<ChatState> emit,
  ) async {
    if (_sessionId != null) {
      try {
        await _repo.ragDeleteSession(_sessionId!);
      } catch (_) {
        // best-effort, errors ignored per spec
      }
      _sessionId = null;
    }
    emit(const ChatInitial());
  }
}
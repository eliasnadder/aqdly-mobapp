part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatIngesting extends ChatState {
  final List<ChatMessage> messages;

  const ChatIngesting(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatReady extends ChatState {
  final List<ChatMessage> messages;

  const ChatReady(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatAnswering extends ChatState {
  final List<ChatMessage> messages;

  const ChatAnswering(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  final List<ChatMessage> messages;

  const ChatError(this.message, this.messages);

  @override
  List<Object?> get props => [message, messages];
}
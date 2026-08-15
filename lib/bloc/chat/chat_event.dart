part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final List<String> clauses; // clause texts from a chosen analysis

  const ChatStarted(this.clauses);

  @override
  List<Object?> get props => [clauses];
}

class QuestionSubmitted extends ChatEvent {
  final String question;

  const QuestionSubmitted(this.question);

  @override
  List<Object?> get props => [question];
}

class ChatClosed extends ChatEvent {
  const ChatClosed();
}
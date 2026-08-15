part of 'analysis_bloc.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisLoading extends AnalysisState {
  final double progress; // 0.0..1.0 (multipart send progress)
  const AnalysisLoading(this.progress);

  @override
  List<Object?> get props => [progress];
}

class AnalysisError extends AnalysisState {
  final String message;
  const AnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalysisSuccess extends AnalysisState {
  final AnalysisResult result; // from models
  const AnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}
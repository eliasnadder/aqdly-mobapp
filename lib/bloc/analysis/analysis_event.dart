part of 'analysis_bloc.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object?> get props => [];
}

class AnalyzeRequested extends AnalysisEvent {
  final PlatformFile file;
  const AnalyzeRequested(this.file);

  @override
  List<Object?> get props => [file];
}

class CancelRequested extends AnalysisEvent {
  const CancelRequested();
}
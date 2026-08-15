part of 'comparison_bloc.dart';

abstract class ComparisonEvent extends Equatable {
  const ComparisonEvent();

  @override
  List<Object?> get props => [];
}

class CompareRequested extends ComparisonEvent {
  final PlatformFile file1;
  final PlatformFile file2;

  const CompareRequested(this.file1, this.file2);

  @override
  List<Object?> get props => [file1, file2];
}
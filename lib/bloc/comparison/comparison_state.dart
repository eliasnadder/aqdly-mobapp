part of 'comparison_bloc.dart';

abstract class ComparisonState extends Equatable {
  const ComparisonState();

  @override
  List<Object?> get props => [];
}

class ComparisonInitial extends ComparisonState {
  const ComparisonInitial();
}

class ComparisonLoading extends ComparisonState {
  const ComparisonLoading();
}

class ComparisonError extends ComparisonState {
  final String message;

  const ComparisonError(this.message);

  @override
  List<Object?> get props => [message];
}

class ComparisonSuccess extends ComparisonState {
  final ComparisonResult result;

  const ComparisonSuccess(this.result);

  @override
  List<Object?> get props => [result];
}
part of 'summary_bloc.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSummary extends SummaryEvent {
  final DateTime month;
  LoadSummary(this.month);
}

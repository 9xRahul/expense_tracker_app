part of 'summary_bloc.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSummary extends SummaryEvent {
  final DateTime month;
  LoadSummary(this.month);
}
class SetSummaryRange extends SummaryEvent {
  final SummaryRange value;
  SetSummaryRange(this.value);

  @override
  List<Object?> get props => [value];
}

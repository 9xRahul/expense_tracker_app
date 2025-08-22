part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final DateTime month;
  LoadExpenses(this.month);
}

class AddExpenseEvent extends ExpenseEvent {
  final ExpenseEntry entry;
  AddExpenseEvent(this.entry);
}

class UpsertLimitEvent extends ExpenseEvent {
  final CategoryLimit limit;
  UpsertLimitEvent(this.limit);
}

class UpdateSearchFilters extends ExpenseEvent {
  final String? description;
  final String? category;
  final DateTime? from;
  final DateTime? to;
  final bool? ascending;

  UpdateSearchFilters({
    this.description,
    this.category,
    this.from,
    this.to,
    this.ascending,
  });

  @override
  List<Object?> get props => [description, category, from, to, ascending];
}

class ExecuteSearch extends ExpenseEvent {}

class ResetAllValues extends ExpenseEvent {
  @override
  List<Object?> get props => [];
}

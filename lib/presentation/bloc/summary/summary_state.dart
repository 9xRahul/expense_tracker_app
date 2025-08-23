part of 'summary_bloc.dart';

class SummaryState extends Equatable {
  final DateTime month;
  final List<ExpenseEntry> expenses;
  final List<IncomeEntry> incomes;
  final double totalExpense;
  final double totalIncome;
  final Map<String, double> categoryExpense;
  List<PieChartSectionData> sections;

  final SummaryRange range;

  SummaryState({
    required this.month,
    required this.expenses,
    required this.incomes,
    required this.totalExpense,
    required this.totalIncome,
    required this.categoryExpense,
    required this.sections,
    required this.range,
  });

  factory SummaryState.initial() => SummaryState(
    month: DateTime.now(),
    expenses: const [],
    incomes: const [],
    totalExpense: 0,
    totalIncome: 0,
    categoryExpense: Map(),
    sections: const [],
    range: SummaryRange.monthly,
  );

  SummaryState copyWith({
    DateTime? month,
    List<ExpenseEntry>? expenses,
    List<IncomeEntry>? incomes,
    double? totalExpense,
    double? totalIncome,
    Map<String, double>? categoryExpense,
    List<PieChartSectionData>? sections,
    SummaryRange? range,
  }) => SummaryState(
    month: month ?? this.month,
    expenses: expenses ?? this.expenses,
    incomes: incomes ?? this.incomes,
    totalExpense: totalExpense ?? this.totalExpense,
    totalIncome: totalIncome ?? this.totalIncome,
    categoryExpense: categoryExpense ?? this.categoryExpense,
    sections: sections ?? this.sections,
    range: range ?? this.range,
  );

  @override
  List<Object?> get props => [
    month,
    expenses,
    incomes,
    totalExpense,
    totalIncome,
    categoryExpense,
    sections,
    range,
  ];
}

part of 'income_bloc.dart';

class IncomeState extends Equatable {
  final String category;
  final String description;
  final String amountText;
  final DateTime? date;
  final List<IncomeEntry> incomeDataList;

  IncomeState({
    required this.category,
    required this.description,
    required this.amountText,
    required this.date,
    required this.incomeDataList,
  });

  IncomeState copyWith({
    String? category,
    String? description,
    String? amountText,
    DateTime? date,
    List<IncomeEntry>? incomeDataList,
  }) {
    return IncomeState(
      category: category ?? this.category,
      description: description ?? this.description,
      amountText: amountText ?? this.amountText,
      date: date ?? this.date,
      incomeDataList: incomeDataList ?? this.incomeDataList,
    );
  }

  @override
  List<Object?> get props => [
    category,
    description,
    amountText,
    date,
    incomeDataList,
  ];
}

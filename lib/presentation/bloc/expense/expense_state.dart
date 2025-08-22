part of 'expense_bloc.dart';

class ExpenseState extends Equatable {
  final List<ExpenseEntry> expenses;
  final List<CategoryLimit> limits;
  final String? error;
  final String? warning;

  
  final String searchDescription;
  final String searchCategory;
  final DateTime? searchFrom;
  final DateTime? searchTo;
  final bool searchAscending;
  final List<ExpenseEntry> searchResults;

  const ExpenseState({
    required this.expenses,
    required this.limits,
    this.error,
    this.warning,
    required this.searchDescription,
    required this.searchCategory,
    required this.searchFrom,
    required this.searchTo,
    required this.searchAscending,
    required this.searchResults,
  });

  factory ExpenseState.initial() => const ExpenseState(
    expenses: [],
    limits: [],
    error: null,
    warning: null,
    searchDescription: '',
    searchCategory: '',
    searchFrom: null,
    searchTo: null,
    searchAscending: false,
    searchResults: [],
  );

  ExpenseState copyWith({
    List<ExpenseEntry>? expenses,
    List<CategoryLimit>? limits,
    String? error,
    String? warning,
    String? searchDescription,
    String? searchCategory,
    DateTime? searchFrom,
    DateTime? searchTo,
    bool? searchAscending,
    List<ExpenseEntry>? searchResults,
  }) => ExpenseState(
    expenses: expenses ?? this.expenses,
    limits: limits ?? this.limits,
    error: error,
    warning: warning,
    searchDescription: searchDescription ?? this.searchDescription,
    searchCategory: searchCategory ?? this.searchCategory,
    searchFrom: searchFrom ?? this.searchFrom,
    searchTo: searchTo ?? this.searchTo,
    searchAscending: searchAscending ?? this.searchAscending,
    searchResults: searchResults ?? this.searchResults,
  );

  @override
  List<Object?> get props => [
    expenses,
    limits,
    error,
    warning,
    searchDescription,
    searchCategory,
    searchFrom,
    searchTo,
    searchAscending,
    searchResults,
  ];
}

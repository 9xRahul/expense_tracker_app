import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/expense_entry.dart';
import '../../../domain/entities/category_limit.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/limit_repository.dart';
import '../../../core/utils/date_utils.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepo;
  final LimitRepository limitRepo;

  ExpenseBloc(this.expenseRepo, this.limitRepo)
    : super(ExpenseState.initial()) {
    on<LoadExpenses>(_loadExpenses);
    on<ResetAllValues>(_resetAllValues);
    on<AddExpenseEvent>(_addExpense);
    on<UpsertLimitEvent>(_upsertLimit);
    on<UpdateSearchFilters>(_updateSearchFilters);
    on<ExecuteSearch>(_executeSearch);
  }

  Future<void> _loadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    final list = await expenseRepo.getExpenses(month: event.month);
    final limits = await limitRepo.getAllLimits();
    emit(
      state.copyWith(
        expenses: list,
        limits: limits,
        error: null,
        warning: null,
      ),
    );
  }

  Future<void> _addExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    final d = DateValidators.parseYMd(event.entry.date);
    if (!DateValidators.isInCurrentMonth(d)) {
      emit(state.copyWith(error: 'Date must be within the current month.'));
      return;
    }

    final limit = await limitRepo.getLimit(event.entry.category);
    String? warning;
    if (limit != null) {
      final spent = await expenseRepo.sumByCategoryMonth(
        event.entry.category,
        d,
      );
      final projected = spent + event.entry.amount;
      if (projected > limit.monthlyLimit) {
        warning =
            'Warning: This will exceed the monthly limit for ${event.entry.category}.';
      }
    }

    await expenseRepo.addExpense(event.entry);
    final list = await expenseRepo.getExpenses(month: DateTime.now());
    emit(state.copyWith(expenses: list, warning: warning, error: null));
  }

  Future<void> _upsertLimit(
    UpsertLimitEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    await limitRepo.upsertLimit(event.limit);
    final limits = await limitRepo.getAllLimits();
    emit(state.copyWith(limits: limits, error: null));
  }

  void _updateSearchFilters(
    UpdateSearchFilters event,
    Emitter<ExpenseState> emit,
  ) {
    emit(
      state.copyWith(
        searchDescription: event.description ?? state.searchDescription,
        searchCategory: event.category ?? state.searchCategory,
        searchFrom: event.from ?? state.searchFrom,
        searchTo: event.to ?? state.searchTo,
        searchAscending: event.ascending ?? state.searchAscending,
      ),
    );
  }

  Future<void> _executeSearch(
    ExecuteSearch event,
    Emitter<ExpenseState> emit,
  ) async {
    final results = await expenseRepo.search(
      description: state.searchDescription.isEmpty
          ? null
          : state.searchDescription,
      category: state.searchCategory.isEmpty ? null : state.searchCategory,
      from: state.searchFrom,
      to: state.searchTo,
      ascending: state.searchAscending,
    );
    emit(state.copyWith(searchResults: results, error: null));
  }

  void _resetAllValues(ResetAllValues event, Emitter<ExpenseState> emit) async {
    final list = await expenseRepo.getExpenses(month: event.month);
    final limits = await limitRepo.getAllLimits();

    emit(
      state.copyWith(
        expenses: list,
        limits: limits,
        error: null,
        warning: null,
        searchDescription: '',
        searchCategory: "All",
        searchFrom: null,
        searchTo: null,
        searchAscending: false,
        searchResults: [],
      ),
    );
  }
}

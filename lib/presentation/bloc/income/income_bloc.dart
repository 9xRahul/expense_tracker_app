import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/core/constants/variables.dart';
import 'package:expense_tracker_app/core/utils/date_utils.dart';
import 'package:expense_tracker_app/domain/entities/income_entry.dart';
import 'package:expense_tracker_app/domain/repositories/income_repository.dart';

part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final IncomeRepository repository;

  IncomeBloc({required this.repository})
    : super(
        IncomeState(
          category: Constants.categories[0],
          description: "",
          amountText: "",
          date: null,
          incomeDataList: const [],
        ),
      ) {
    on<IncomeSetCategory>(_setCategory);
    on<IncomeSetDescription>(_setDescription);
    on<IncomeSetAmountText>(_setAmountText);
    on<IncomeSetDate>(_setDate);
    on<IncomeFormReset>(_resetForm);
    on<AddIncomeEvent>(_addIncome);
    on<LoadIncomes>(_loadIncomes);
  }

  Future<void> _loadIncomes(
    LoadIncomes event,
    Emitter<IncomeState> emit,
  ) async {
    final list = await repository.getIncomes(month: event.month);
    emit(state.copyWith(incomeDataList: list));
  }

  Future<void> _addIncome(
    AddIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    final pickedDate = DateValidators.parseYMd(event.entry.date);
    if (!DateValidators.isInCurrentMonth(pickedDate)) {
      return;
    }

    await repository.addIncome(event.entry);

    final now = DateTime.now();
    final refreshed = await repository.getIncomes(month: now);

    emit(
      state.copyWith(
        category: Constants.categories[0],
        description: "",
        amountText: "",
        date: null,
        incomeDataList: refreshed,
      ),
    );
  }

  void _setCategory(IncomeSetCategory event, Emitter<IncomeState> emit) {
    emit(state.copyWith(category: event.value));
  }

  void _setDescription(IncomeSetDescription event, Emitter<IncomeState> emit) {
    emit(state.copyWith(description: event.value));
  }

  void _setAmountText(IncomeSetAmountText event, Emitter<IncomeState> emit) {
    emit(state.copyWith(amountText: event.value));
  }

  void _setDate(IncomeSetDate event, Emitter<IncomeState> emit) {
    emit(state.copyWith(date: event.value));

    add(LoadIncomes(DateTime(event.value.year, event.value.month, 1)));
  }

  void _resetForm(IncomeFormReset event, Emitter<IncomeState> emit) {
    emit(
      state.copyWith(
        category: Constants.categories[0],
        description: "",
        amountText: "",
        date: null,
      ),
    );
  }
}

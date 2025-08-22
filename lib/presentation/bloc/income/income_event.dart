part of 'income_bloc.dart';

abstract class IncomeEvent {}

class IncomeSetCategory extends IncomeEvent {
  final String value;
  IncomeSetCategory(this.value);
}

class IncomeSetDescription extends IncomeEvent {
  final String value;
  IncomeSetDescription(this.value);
}

class IncomeSetAmountText extends IncomeEvent {
  final String value;
  IncomeSetAmountText(this.value);
}

class IncomeSetDate extends IncomeEvent {
  final DateTime value;
  IncomeSetDate(this.value);
}

class IncomeFormReset extends IncomeEvent {}

class AddIncomeEvent extends IncomeEvent {
  final IncomeEntry entry;
  AddIncomeEvent(this.entry);
}

class LoadIncomes extends IncomeEvent {
  final DateTime month;
  LoadIncomes(this.month);
}

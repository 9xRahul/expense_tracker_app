import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/limit_repository.dart';
import '../../../domain/entities/expense_entry.dart';
import '../../../domain/entities/income_entry.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final ExpenseRepository expenseRepo;
  final IncomeRepository incomeRepo;
  final LimitRepository limitRepo;

  SummaryBloc(this.expenseRepo, this.incomeRepo, this.limitRepo)
    : super(SummaryState.initial()) {
    on<LoadSummary>(_loadSummaryForNow);
  }
  void _loadSummaryForNow(LoadSummary event, Emitter<SummaryState> emit) async {
    final expenses = await expenseRepo.getExpenses(month: event.month);
    final incomes = await incomeRepo.getIncomes(month: event.month);
    final totalExpense = expenses.fold<double>(0.0, (p, e) => p + e.amount);
    final totalIncome = incomes.fold<double>(0.0, (p, e) => p + e.amount);

    final byCategory = groupBy<ExpenseEntry, String>(
      expenses,
      (e) => e.category,
    ).map((k, v) => MapEntry(k, v.fold<double>(0, (p, e) => p + e.amount)));

    final sections = byCategory.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;
      final color =
          ColorConfig.pidiagramColors[index %
              ColorConfig.pidiagramColors.length]; 
      return PieChartSectionData(
        value: e.value,
        title: e.key,
        color: color,
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    emit(
      state.copyWith(
        month: event.month,
        expenses: expenses,
        incomes: incomes,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        categoryExpense: byCategory,
        sections: sections,
      ),
    );
  }
}

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/variables.dart';
import 'package:expense_tracker_app/core/utils/date_utils.dart';
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
    on<SetSummaryRange>(_setRangeAndRebuild);
  }

  Future<void> _loadSummaryForNow(
    LoadSummary event,
    Emitter<SummaryState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final List<ExpenseEntry> expenses = await expenseRepo.getExpenses(
      month: event.month,
    );
    final List<IncomeEntry> incomes = await incomeRepo.getIncomes(
      month: event.month,
    );

    double totalExpense = 0.0;
    for (final e in expenses) {
      totalExpense = totalExpense + e.amount;
    }

    double totalIncome = 0.0;
    for (final i in incomes) {
      totalIncome = totalIncome + i.amount;
    }

    final List<ExpenseEntry> filtered = _filterByRange(
      expenses,
      state.range,
      month: event.month,
    );
    final Map<String, double> byCategory = _sumByCategory(filtered);
    final List<PieChartSectionData> sections = _buildPieSections(byCategory);

    emit(
      state.copyWith(
        month: event.month,
        expenses: expenses,
        incomes: incomes,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        categoryExpense: byCategory,
        sections: sections,
        loading: false,
      ),
    );
  }

  void _setRangeAndRebuild(SetSummaryRange event, Emitter<SummaryState> emit) {
    final List<ExpenseEntry> filtered = _filterByRange(
      state.expenses,
      event.value,
      month: state.month,
    );
    final Map<String, double> byCategory = _sumByCategory(filtered);
    final List<PieChartSectionData> sections = _buildPieSections(byCategory);

    emit(
      state.copyWith(
        range: event.value,
        categoryExpense: byCategory,
        sections: sections,
      ),
    );
  }
}

List<ExpenseEntry> _filterByRange(
  List<ExpenseEntry> items,
  SummaryRange range, {
  required DateTime month,
}) {
  final DateTime now = DateTime.now();
  final DateTime todayStart = DateTime(now.year, now.month, now.day);
  final DateTime weekStart = _startOfWeek(now);
  final DateTime monthStart = DateTime(month.year, month.month, 1);
  final DateTime monthEnd = DateTime(month.year, month.month + 1, 0);

  bool inDay(DateTime d) {
    return !d.isBefore(todayStart) &&
        d.isBefore(todayStart.add(const Duration(days: 1)));
  }

  bool inWeek(DateTime d) {
    return !d.isBefore(weekStart) && !d.isAfter(now);
  }

  bool inMonth(DateTime d) {
    return !d.isBefore(monthStart) && !d.isAfter(monthEnd);
  }

  final List<ExpenseEntry> result = <ExpenseEntry>[];

  for (final item in items) {
    final DateTime d = DateValidators.parseYMd(item.date);
    if (range == SummaryRange.daily) {
      if (inDay(d)) {
        result.add(item);
      }
    } else if (range == SummaryRange.weekly) {
      if (inWeek(d)) {
        result.add(item);
      }
    } else {
      if (inMonth(d)) {
        result.add(item);
      }
    }
  }

  return result;
}

Map<String, double> _sumByCategory(List<ExpenseEntry> entries) {
  final Map<String, List<ExpenseEntry>> grouped = groupBy<ExpenseEntry, String>(
    entries,
    (e) {
      return e.category;
    },
  );

  final Map<String, double> sums = <String, double>{};

  grouped.forEach((String key, List<ExpenseEntry> list) {
    double total = 0.0;
    for (final e in list) {
      total = total + e.amount;
    }
    sums[key] = total;
  });

  return sums;
}

List<PieChartSectionData> _buildPieSections(Map<String, double> byCategory) {
  final List<MapEntry<String, double>> ordered = byCategory.entries.toList();

  ordered.sort((a, b) {
    if (a.value > b.value) {
      return -1;
    } else if (a.value < b.value) {
      return 1;
    } else {
      return 0;
    }
  });

  final List<PieChartSectionData> sections = <PieChartSectionData>[];

  for (int i = 0; i < ordered.length; i++) {
    final MapEntry<String, double> e = ordered[i];
    final Color color =
        ColorConfig.pidiagramColors[i % ColorConfig.pidiagramColors.length];
    final Color textColor = Color(0xFF000000);

    sections.add(
      PieChartSectionData(
        value: e.value,
        title: e.key,
        color: color,
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  return sections;
}

DateTime _startOfWeek(DateTime d) {
  final int weekday = d.weekday;
  return DateTime(d.year, d.month, d.day).subtract(Duration(days: weekday - 1));
}

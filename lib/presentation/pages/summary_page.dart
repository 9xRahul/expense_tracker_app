import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_entry.dart';
import '../bloc/summary/summary_bloc.dart';

@RoutePage()
class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});
  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  void initState() {
    super.initState();
    context.read<SummaryBloc>().add(LoadSummary(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.primary,

        title: Text(
          TextValues.summary,
          style: TextStyle(color: ColorConfig.selectedIconColors),
        ),
        iconTheme: IconThemeData(color: ColorConfig.selectedIconColors),
      ),
      body: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          final recent = state.expenses.take(10).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Center(
                    child: Column(
                      children: [
                        Text('Income'),
                        Text('₹${state.totalIncome.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Center(
                    child: Column(
                      children: [
                        Text('Expence'),
                        Text('₹${state.totalExpense}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Card(
                  child: Center(
                    child: Column(
                      children: [
                        Text('Savings'),
                        Text(
                          '₹${(state.totalIncome - state.totalExpense).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                state.sections.isEmpty
                    ? const Center(
                        child: Text('No expenses so far in this month'),
                      )
                    : SizedBox(
                        height: 260,
                        child: PieChart(PieChartData(sections: state.sections)),
                      ),
                const SizedBox(height: 24),
                Text(
                  state.sections.isEmpty ? "" : 'Recent Expenses',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  itemBuilder: (context, index) {
                    final e = recent[index];
                    final title =
                        e.subCategory == null || e.subCategory!.isEmpty
                        ? e.category
                        : '${e.category} • ${e.subCategory}';
                    return ListTile(
                      leading: const Icon(Icons.payments),
                      title: Text(title),
                      subtitle: Text(e.description ?? ''),
                      trailing: Text('₹${e.amount.toStringAsFixed(2)}'),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:expense_tracker_app/core/constants/variables.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          final List recent = state.expenses.length > 10
              ? state.expenses.sublist(0, 10)
              : state.expenses;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Income'),
                          Text('₹${state.totalIncome.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Expence'),
                          Text('₹${state.totalExpense}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Savings'),
                          Text(
                            '₹${(state.totalIncome - state.totalExpense).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Show by',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    DropdownButton<SummaryRange>(
                      value: state.range,
                      onChanged: (v) {
                        if (v != null) {
                          context.read<SummaryBloc>().add(SetSummaryRange(v));
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: SummaryRange.monthly,
                          child: Text('Monthly'),
                        ),
                        DropdownMenuItem(
                          value: SummaryRange.weekly,
                          child: Text('Weekly'),
                        ),
                        DropdownMenuItem(
                          value: SummaryRange.daily,
                          child: Text('Daily'),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Builder(
                  builder: (context) {
                    if (state.sections.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: state.loading
                              ? CircularProgressIndicator()
                              : Text('No expenses so far in this period'),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 260,
                      child: PieChart(
                        PieChartData(
                          sections: state.sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 32,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                Text(
                  state.sections.isEmpty ? "" : 'Recent Expenses',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  itemBuilder: (context, index) {
                    final e = recent[index];
                    final String title;
                    if (e.subCategory == null || e.subCategory.isEmpty) {
                      title = e.category;
                    } else {
                      title = '${e.category} - ${e.subCategory}';
                    }
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

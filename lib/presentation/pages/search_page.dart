import 'package:auto_route/auto_route.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/date_utils.dart';
import '../bloc/expense/expense_bloc.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ExpenseBloc>().add(ExecuteSearch());
  }

  @override
  Widget build(BuildContext context) {
    final descCtrl = TextEditingController();

    const categories = <String>[
      'All',
      'Entertainment',
      'Food',
      'Transportation',
      'Utilities',
      'Shopping',
      'Other',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.primary,
        title: Text(
          TextValues.search,
          style: TextStyle(color: ColorConfig.selectedIconColors),
        ),
        iconTheme: IconThemeData(color: ColorConfig.selectedIconColors),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (descCtrl.text != state.searchDescription) {
              descCtrl.text = state.searchDescription;
              descCtrl.selection = TextSelection.collapsed(
                offset: descCtrl.text.length,
              );
            }

            final selectedCategoryValue = state.searchCategory.isEmpty
                ? 'All'
                : state.searchCategory;

            return ListView(
              children: [
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Search description',
                  ),
                  onChanged: (v) => context.read<ExpenseBloc>().add(
                    UpdateSearchFilters(description: v),
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedCategoryValue,
                  decoration: const InputDecoration(
                    labelText: 'Filter by category',
                  ),
                  items: categories
                      .map(
                        (c) =>
                            DropdownMenuItem<String>(value: c, child: Text(c)),
                      )
                      .toList(),
                  onChanged: (value) {
                    final cat = (value == null || value == 'All') ? '' : value;
                    context.read<ExpenseBloc>().add(
                      UpdateSearchFilters(category: cat),
                    );
                    context.read<ExpenseBloc>().add(ExecuteSearch());
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'From: ${state.searchFrom != null ? DateValidators.yMd(state.searchFrom!) : '-'}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.searchFrom ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          context.read<ExpenseBloc>().add(
                            UpdateSearchFilters(from: picked),
                          );
                          context.read<ExpenseBloc>().add(ExecuteSearch());
                        }
                      },
                      child: const Text('Pick'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'To: ${state.searchTo != null ? DateValidators.yMd(state.searchTo!) : '-'}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.searchTo ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          context.read<ExpenseBloc>().add(
                            UpdateSearchFilters(to: picked),
                          );
                          context.read<ExpenseBloc>().add(ExecuteSearch());
                        }
                      },
                      child: const Text('Pick'),
                    ),
                  ],
                ),

                SwitchListTile(
                  title: Text(
                    state.searchAscending
                        ? 'Sort: Ascending'
                        : 'Sort: Descending',
                  ),
                  value: state.searchAscending,
                  onChanged: (v) {
                    context.read<ExpenseBloc>().add(
                      UpdateSearchFilters(ascending: v),
                    );
                    context.read<ExpenseBloc>().add(ExecuteSearch());
                  },
                ),

                ElevatedButton(
                  onPressed: () =>
                      context.read<ExpenseBloc>().add(ExecuteSearch()),
                  child: const Text('Search'),
                ),

                const SizedBox(height: 12),

                Column(
                  children: state.searchResults.map((e) {
                    return ListTile(
                      leading: const Icon(Icons.payments),
                      title: Text('${e.category} ${e.subCategory ?? ""}'),
                      subtitle: Text('${e.description ?? ""} • ${e.date}'),
                      trailing: Text('₹${e.amount.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

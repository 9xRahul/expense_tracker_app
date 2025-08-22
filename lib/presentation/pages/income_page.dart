import 'package:auto_route/auto_route.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:expense_tracker_app/core/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/income_entry.dart';
import '../bloc/income/income_bloc.dart';

@RoutePage()
class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<IncomeBloc>().add(LoadIncomes(DateTime.now()));

    final formKey = GlobalKey<FormState>();

    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorConfig.primary,
        title: Text(
          TextValues.income,
          style: TextStyle(color: ColorConfig.selectedIconColors),
        ),
        iconTheme: IconThemeData(color: ColorConfig.selectedIconColors),
      ),
      body: BlocBuilder<IncomeBloc, IncomeState>(
        builder: (context, state) {
          if (descCtrl.text != state.description) {
            descCtrl.text = state.description;
            descCtrl.selection = TextSelection.collapsed(
              offset: descCtrl.text.length,
            );
          }
          if (amountCtrl.text != state.amountText) {
            amountCtrl.text = state.amountText;
            amountCtrl.selection = TextSelection.collapsed(
              offset: amountCtrl.text.length,
            );
          }

          final pickedDate = state.date ?? DateTime.now();
          final categoryValue = Constants.categories.contains(state.category)
              ? state.category
              : Constants.categories[0];

          final selectedMonthStart = DateTime(
            pickedDate.year,
            pickedDate.month,
            1,
          );
          final selectedDayInclusive = pickedDate;
          final filtered = state.incomeDataList.where((e) {
            final d = DateValidators.parseYMd(e.date);
            return d.year == pickedDate.year &&
                d.month == pickedDate.month &&
                !d.isAfter(selectedDayInclusive);
          }).toList();
          final tillThatDay = filtered.fold<double>(
            0.0,
            (sum, e) => sum + e.amount,
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.5,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: categoryValue,
                            items: Constants.categories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => context.read<IncomeBloc>().add(
                              IncomeSetCategory(v ?? Constants.categories[0]),
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                          ),
                          TextFormField(
                            controller: descCtrl,
                            maxLength: 256,
                            decoration: const InputDecoration(
                              labelText: 'Description (optional)',
                            ),
                            onChanged: (v) => context.read<IncomeBloc>().add(
                              IncomeSetDescription(v),
                            ),
                          ),
                          TextFormField(
                            controller: amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Enter amount'
                                : null,
                            onChanged: (v) => context.read<IncomeBloc>().add(
                              IncomeSetAmountText(v),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Date: ${DateValidators.yMd(pickedDate)}'),
                              const Spacer(),
                              TextButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: pickedDate,
                                    firstDate: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      1,
                                    ),
                                    lastDate: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month + 1,
                                      0,
                                    ),
                                  );
                                  if (picked != null) {
                                    context.read<IncomeBloc>().add(
                                      IncomeSetDate(picked),
                                    );
                                  }
                                },
                                child: const Text('Pick'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final amount =
                                    double.tryParse(state.amountText.trim()) ??
                                    0.0;
                                final entry = IncomeEntry(
                                  category: categoryValue,
                                  description: state.description.isEmpty
                                      ? null
                                      : state.description,
                                  amount: amount,
                                  date: DateValidators.yMd(pickedDate),
                                );
                                context.read<IncomeBloc>().add(
                                  AddIncomeEvent(entry),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Income added')),
                                );
                              }
                            },
                            child: const Text('Add Income'),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Income till today for this month',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'From ${DateValidators.yMd(selectedMonthStart)} '
                            'to ${DateValidators.yMd(selectedDayInclusive)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1),

                          Expanded(
                            child: filtered.isEmpty
                                ? const Center(child: Text('No incomes yet'))
                                : ListView.builder(
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final item = filtered[index];
                                      final title = item.category;
                                      final subtitle =
                                          item.description?.isNotEmpty == true
                                          ? '${item.description} • ${item.date}'
                                          : item.date;
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.monetization_on,
                                        ),
                                        title: Text(title),
                                        subtitle: Text(subtitle),
                                        trailing: Text(
                                          '₹${item.amount.toStringAsFixed(2)}',
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 0.0,
                                            ),
                                      );
                                    },
                                  ),
                          ),

                          const Divider(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total: ₹${tillThatDay.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/expense_entry.dart';
import '../../domain/entities/category_limit.dart';
import '../bloc/expense/expense_bloc.dart';

@RoutePage()
class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _limitFormKey = GlobalKey<FormState>();

  final _categoryFieldKey = GlobalKey<FormFieldState<String>>();
  final _limitCategoryFieldKey = GlobalKey<FormFieldState<String>>();

  final _categories = const [
    'Entertainment',
    'Food',
    'Transportation',
    'Utilities',
    'Shopping',
    'Other',
  ];
  final _subCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _limitAmountCtrl = TextEditingController();

  final _dateCtrl = TextEditingController();
  DateTime _pickedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateCtrl.text = DateValidators.yMd(_pickedDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseBloc>().add(LoadExpenses(DateTime.now()));
      _categoryFieldKey.currentState?.didChange(_categories.first);
      _limitCategoryFieldKey.currentState?.didChange(_categories.first);
    });
  }

  @override
  void dispose() {
    _subCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    _limitAmountCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorConfig.primary,
        title: Text(
          TextValues.expense,
          style: TextStyle(color: ColorConfig.selectedIconColors),
        ),
        iconTheme: IconThemeData(color: ColorConfig.selectedIconColors),
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.warning != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.warning!)));
          }
        },
        builder: (context, state) {
          final monthFiltered = state.expenses.where((e) {
            final d = DateValidators.parseYMd(e.date);
            return d.year == _pickedDate.year && d.month == _pickedDate.month;
          }).toList()..sort((a, b) => b.date.compareTo(a.date));

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,

                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            key: _categoryFieldKey,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                            items: _categories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {},
                          ),
                          TextFormField(
                            controller: _subCtrl,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              labelText: 'Sub-Category (optional)',
                            ),
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                          ),

                          SizedBox(
                            height: 120,
                            child: TextFormField(
                              controller: _descCtrl,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              maxLength: 256,
                              scrollPadding: const EdgeInsets.only(bottom: 160),
                              decoration: const InputDecoration(
                                labelText: 'Description (optional)',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Enter amount'
                                : null,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _dateCtrl,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Date (current month)',
                                  ),
                                  scrollPadding: const EdgeInsets.only(
                                    bottom: 100,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              TextButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _pickedDate,
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
                                    _pickedDate = picked;
                                    _dateCtrl.text = DateValidators.yMd(
                                      _pickedDate,
                                    );

                                    context.read<ExpenseBloc>().add(
                                      LoadExpenses(
                                        DateTime(
                                          _pickedDate.year,
                                          _pickedDate.month,
                                          1,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Pick'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              final category =
                                  _categoryFieldKey.currentState?.value ??
                                  _categories.first;
                              final amount =
                                  double.tryParse(_amountCtrl.text.trim()) ??
                                  0.0;

                              final entry = ExpenseEntry(
                                category: category,
                                subCategory: _subCtrl.text.isNotEmpty
                                    ? _subCtrl.text
                                    : null,
                                description: _descCtrl.text.isNotEmpty
                                    ? _descCtrl.text
                                    : null,
                                amount: amount,
                                date: DateValidators.yMd(_pickedDate),
                              );
                              context.read<ExpenseBloc>().add(
                                AddExpenseEvent(entry),
                              );
                              context.read<ExpenseBloc>().add(ResetAllValues());
                            },
                            child: const Text('Add Expense'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Form(
                      key: _limitFormKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              key: _limitCategoryFieldKey,
                              decoration: const InputDecoration(
                                labelText: 'Limit Category',
                              ),
                              items: _categories
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _limitAmountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Monthly Limit',
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Amount' : null,
                              scrollPadding: const EdgeInsets.only(bottom: 120),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (!_limitFormKey.currentState!.validate())
                                return;

                              final limitCategory =
                                  _limitCategoryFieldKey.currentState?.value ??
                                  _categories.first;
                              final limitAmount =
                                  double.tryParse(
                                    _limitAmountCtrl.text.trim(),
                                  ) ??
                                  0.0;

                              final limit = CategoryLimit(
                                category: limitCategory,
                                monthlyLimit: limitAmount,
                              );
                              context.read<ExpenseBloc>().add(
                                UpsertLimitEvent(limit),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Limit saved')),
                              );
                            },
                            child: const Text('Save Limit'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: monthFiltered.isEmpty
                          ? const SizedBox(
                              height: 120,
                              child: Center(
                                child: Text('No expenses for this month yet'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: monthFiltered.length,
                              itemBuilder: (context, index) {
                                final e = monthFiltered[index];
                                final subtitle = [
                                  if (e.subCategory != null &&
                                      e.subCategory!.isNotEmpty)
                                    e.subCategory!,
                                  if (e.description != null &&
                                      e.description!.isNotEmpty)
                                    e.description!,
                                  e.date,
                                ].join('  ');
                                return ListTile(
                                  leading: const Icon(Icons.payments),
                                  title: Text(e.category),
                                  subtitle: Text(subtitle),
                                  trailing: Text(
                                    '₹${e.amount.toStringAsFixed(2)}',
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

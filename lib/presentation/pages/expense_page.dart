import 'package:auto_route/annotations.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.primary, // Black background
        leading: BackButton(
          color: ColorConfig.selectedIconColors, // White back arrow
        ),
        title: Text(
          TextValues.expense,
          style: TextStyle(
            color: ColorConfig.selectedIconColors, // White title text
          ),
        ),
        iconTheme: IconThemeData(
          color: ColorConfig.selectedIconColors,
        ), // Ensures all icons are white
      ),
    );
  }
}

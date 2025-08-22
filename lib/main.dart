import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  final appRouter = AppRouter();

  runApp(ExpenseApp(appRouter: appRouter));
}

class ExpenseApp extends StatelessWidget {
  final AppRouter appRouter;
  const ExpenseApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
    );
  }
}

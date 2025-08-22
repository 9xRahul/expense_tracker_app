import 'package:expense_tracker_app/core/db/app_database.dart';
import 'package:expense_tracker_app/data/datasources/local_data_source.dart';
import 'package:expense_tracker_app/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_app/data/repositories/income_repository_impl.dart';
import 'package:expense_tracker_app/data/repositories/limit_repository_impl.dart';
import 'package:expense_tracker_app/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_app/domain/repositories/income_repository.dart';
import 'package:expense_tracker_app/domain/repositories/limit_repository.dart';
import 'package:expense_tracker_app/presentation/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker_app/presentation/bloc/income/income_bloc.dart';
import 'package:expense_tracker_app/presentation/bloc/summary/summary_bloc.dart';
import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final db = await AppDatabase.open(dbPath: dir.path);
  final local = LocalDataSource(db);

  final expenseRepo = ExpenseRepositoryImpl(local);
  final incomeRepo = IncomeRepositoryImpl(local);
  final limitRepo = LimitRepositoryImpl(local);

  final appRouter = AppRouter();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExpenseRepository>.value(value: expenseRepo),
        RepositoryProvider<IncomeRepository>.value(value: incomeRepo),
        RepositoryProvider<LimitRepository>.value(value: limitRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                ExpenseBloc(expenseRepo, limitRepo)
                  ..add(LoadExpenses(DateTime.now())),
          ),
          BlocProvider(
            create: (_) => SummaryBloc(expenseRepo, incomeRepo, limitRepo),
          ),
          BlocProvider(create: (_) => IncomeBloc(repository: incomeRepo)),
        ],
        child: ExpenseApp(appRouter: appRouter),
      ),
    ),
  );
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

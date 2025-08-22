import 'package:auto_route/auto_route.dart';

import '../presentation/pages/home_page.dart';
import '../presentation/pages/income_page.dart';
import '../presentation/pages/expense_page.dart';
import '../presentation/pages/summary_page.dart';
import '../presentation/pages/search_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: IncomeRoute.page),
    AutoRoute(page: ExpenseRoute.page),
    AutoRoute(page: SummaryRoute.page),
    AutoRoute(page: SearchRoute.page),
  ];
}

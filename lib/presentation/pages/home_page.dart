import 'package:auto_route/auto_route.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:expense_tracker_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:expense_tracker_app/presentation/pages/expense_page.dart';
import 'package:expense_tracker_app/presentation/pages/income_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'summary_page.dart';
import 'search_page.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _pages = const [
    SummaryPage(),
    IncomePage(),
    ExpensePage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.index],
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((
                  states,
                ) {
                  if (states.contains(MaterialState.selected)) {
                    return const TextStyle(color: Colors.white);
                  }
                  return const TextStyle(color: Colors.grey);
                }),
              ),
              child: NavigationBar(
                backgroundColor: ColorConfig.primary,
                selectedIndex: state.index,
                indicatorColor: Colors.transparent,
                onDestinationSelected: (i) =>
                    context.read<NavigationBloc>().add(NavigationSetIndex(i)),
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.pie_chart, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.pie_chart,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: TextValues.summary,
                  ),

                  NavigationDestination(
                    icon: Icon(
                      Icons.add_card,
                      color: ColorConfig.unSelectedIconColors,
                    ),
                    selectedIcon: Icon(
                      Icons.add_card,
                      size: 30,
                      color: ColorConfig.selectedIconColors,
                    ),
                    label: TextValues.income,
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.remove_circle,
                      color: ColorConfig.unSelectedIconColors,
                    ),
                    selectedIcon: Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: ColorConfig.selectedIconColors,
                    ),
                    label: TextValues.expense,
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.search,
                      color: ColorConfig.unSelectedIconColors,
                    ),
                    label: TextValues.search,
                    selectedIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: ColorConfig.selectedIconColors,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

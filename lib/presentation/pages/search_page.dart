import 'package:auto_route/annotations.dart';
import 'package:expense_tracker_app/core/constants/color_config.dart';
import 'package:expense_tracker_app/core/constants/text_values.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.primary, // Black background
        leading: BackButton(
          color: ColorConfig.selectedIconColors, // White back arrow
        ),
        title: Text(
          TextValues.search,
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

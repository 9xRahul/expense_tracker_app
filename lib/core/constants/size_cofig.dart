import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double safeAreaTop;
  static late double safeAreaBottom;
  static late double textScaleFactor;
  static late Orientation orientation;

  /// Base design sizes (change according to your design)
  static const double baseWidth = 375.0;
  static const double baseHeight = 812.0;

  /// Initialize once in root widget
  static void initialize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    safeAreaTop = mediaQuery.padding.top;
    safeAreaBottom = mediaQuery.padding.bottom;
    textScaleFactor = mediaQuery.textScaleFactor;
    orientation = mediaQuery.orientation;
  }

  /// Scale width based on device
  static double scaleWidth(double designWidth) =>
      (designWidth / baseWidth) * screenWidth;

  /// Scale height based on device
  static double scaleHeight(double designHeight) =>
      (designHeight / baseHeight) * screenHeight;

  /// Scale font size responsively
  static double scaleFontSize(double fontSize) =>
      fontSize * (screenWidth / baseWidth);

  /// Padding helpers
  static EdgeInsets paddingAll(double value) =>
      EdgeInsets.all(scaleWidth(value));

  static EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: scaleWidth(horizontal),
    vertical: scaleHeight(vertical),
  );

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: scaleWidth(left),
    top: scaleHeight(top),
    right: scaleWidth(right),
    bottom: scaleHeight(bottom),
  );

  /// Margin helpers
  static EdgeInsets marginAll(double value) => paddingAll(value);

  static EdgeInsets marginSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) => paddingSymmetric(horizontal: horizontal, vertical: vertical);

  static EdgeInsets marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => paddingOnly(left: left, top: top, right: right, bottom: bottom);

  /// Configurable values with named parameters
  final double authLogoHeight;
  final double authLogoWidth;

  // Drawer
  final double drawerIconSize;
  final double drawerFontSize;

  // AppBar
  final double appBarIconSize;
  final double appBarFontSize;

  /// Constructor with named parameters (defaults provided)
  SizeConfig({
    this.authLogoHeight = 200,
    this.authLogoWidth = 200,
    this.drawerIconSize = 20,
    this.drawerFontSize = 15,
    this.appBarIconSize = 20,
    this.appBarFontSize = 20,
  });
}

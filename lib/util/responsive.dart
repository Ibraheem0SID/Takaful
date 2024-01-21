import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({super.key, this.mobile, this.tablet, this.desktop})
      : super();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double widthOfScreen(
          {required BuildContext context, double width = 1}) =>
      width * MediaQuery.of(context).size.width;

  static double heightOfScreen(
          {required BuildContext context, double height = 1}) =>
      height * MediaQuery.of(context).size.height;

  static double setWidth(
      BuildContext context, double mobile, double tablet, double desktop) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      if (_size.width < 850) {
        return mobile!;
      } else if (_size.width >= 850 && _size.width < 1100) {
        return tablet!;
      } else {
        return desktop!;
      }
    });
  }
}

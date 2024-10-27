import 'package:flutter/widgets.dart';

class ScreenSize {
  final double width;
  final double height;

  ScreenSize(BuildContext context)
      : width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

  /// Gets screen width as percentage
  double widthPercentage(double percentage) {
    return width * percentage / 100;
  }

  /// Gets screen height as percentage
  double heightPercentage(double percentage) {
    return height * percentage / 100;
  }

  /// Responsive text sizing
  double textSize(double percentage) {
    return width * percentage / 100;
  }
}

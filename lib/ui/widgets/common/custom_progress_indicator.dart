import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';

class CustomCircleProgressIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  CustomCircleProgressIndicator({this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size == null ? 20 : size,
      width: size == null ? 20 : size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color?>(
          color == null ? Color(0xffCC4113) : color,
        ),
      ),
    );
  }
}

class AppBarCircleProgressIndicator extends StatelessWidget {
  final Color color;
  final double size;

  AppBarCircleProgressIndicator({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CustomCircleProgressIndicator(
          color: color,
          size: 14,
        ),
      ),
    );
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  final Color? color;

  const CustomLinearProgressIndicator({this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: 1,
        width: screenWidth(context),
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(
            color == null ? Colors.black38 : color,
          ),
        ),
      ),
    );
  }
}

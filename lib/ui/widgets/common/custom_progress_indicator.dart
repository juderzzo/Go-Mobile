import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';

class CustomCircleProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  const CustomCircleProgressIndicator({this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: size == null ? 20 : size,
        width: size == null ? 20 : size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color == null ? Colors.black38 : color,
          ),
        ),
      ),
    );
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  final Color color;

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
          valueColor: AlwaysStoppedAnimation<Color>(
            color == null ? Colors.black38 : color,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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

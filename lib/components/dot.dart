import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  Dot({this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10.0), child: Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFFFDFEFF),
          width: 1.0,
        ),
        color: filled ? Color(0xFFFDFEFF) : Colors.transparent,
      ),
      
    ));
  }
}

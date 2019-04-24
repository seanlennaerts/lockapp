import 'package:flutter/material.dart';

class Digit extends StatefulWidget {
  Digit({this.number, this.onTap});

  final String number;
  final onTap;

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> {
  bool pressed;

  @override
  void initState() {
    super.initState();
    pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
        highlightColor: Colors.transparent,
        splashColor: Colors.red[50],
        radius: 24.0,
        onTap: widget.onTap,
        onHighlightChanged: ((bool pressed) {
          setState(() => this.pressed = pressed);
        }),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pressed ? Colors.red : Color(0xFFFDFEFF),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 2.0),
                    color: Colors.grey[100],
                    blurRadius: 5.0,
                  )
                ]),
            child: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Center(
                    child: Text(
                  widget.number,
                  style: TextStyle(
                      color: pressed ? Color(0xFFFDFEFF) : Colors.red),
                )))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';

import 'package:lockapp/components/digit.dart';
import 'package:lockapp/components/dot.dart';
import 'package:lockapp/components/shake_animation_widget.dart';

import 'dart:async';

class Lock extends StatefulWidget {
  Lock({this.heading, @required this.create});
  //TODO: use alt constructors instead of passing silly bool
  final String heading;
  final bool create;

  @override
  _LockState createState() => _LockState();
}

enum Mode {
  create,
  authenticate,
  //change,
  //remove
}

class _LockState extends State<Lock> with SingleTickerProviderStateMixin {
  AnimationController controller;
  List<int> pin;
  Mode mode;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    pin = [];
    if (widget.create) {
      mode = Mode.create;
    } else {
      mode = Mode.authenticate;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    controller.dispose();
    super.dispose();
  }

  animateDots() async {
    controller.reset();
    await controller.forward();
    setState(() => pin.clear());
  }

  // bool checkPin() {
  //   if (pin.length == 4 && !ListEquality().equals(pin, widget.testPin)) {
  //     // Vibrate.feedback(FeedbackType.error);
  //     animateDots();
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  addToPin(int n) {
    if (pin.length < 4) {
      setState(() => pin.add(n));
      if (pin.length == 4) {
        switch (mode) {
          case Mode.create:
            Navigator.pop(context, pin);
            break;
          case Mode.authenticate:
              Navigator.pop(context, int.parse((pin.join(''))));
            break;
        }
      }
    }
  }

  Widget buildDigit(int n) {
    return Padding(
      child: Digit(number: n.toString(), onTap: () => addToPin(n)),
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
    );
  }

  List<Dot> buildDots() {
    List<Dot> dots = [];
    for (int i = 0; i < 4; i++) {
      dots.add(Dot(filled: i < pin.length));
    }
    return dots;
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));


    final Color backgroundColor = Color(0xFFFDFEFF);

    final dots = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildDots(),
    );

    final deleteButton = GestureDetector(
        child: Container(
            color: backgroundColor,
            // Colors.red, // change to red to show hitbox
            height: 27.0,
            width:
                26.0, // 22 on width + 10 on margin adds to 32.0, wanted to extend hitbox of delete butotn
            margin: EdgeInsets.fromLTRB(6.0, 5.0, 0.0,
                0.0), // ...without showing up on 0's or 9's ink splash
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 3.0, 5.0),
            child: Icon(
              Icons.backspace,
              color: Colors.red,
              size: 15.0,
            )),
        onTap: () => setState(() {
              if (pin.length > 0) {
                pin.removeLast();
              }
            }));

    final passCode = FittedBox(
        fit: BoxFit.contain,
        child: Column(children: [
          Row(children: [
            buildDigit(1),
            buildDigit(2),
            buildDigit(3),
          ]),
          Row(children: [
            buildDigit(4),
            buildDigit(5),
            buildDigit(6),
          ]),
          Row(children: [
            buildDigit(7),
            buildDigit(8),
            buildDigit(9),
          ]),
          Row(children: [
            SizedBox(
              width: 32.0,
            ),
            buildDigit(0),
            deleteButton,
          ]),
        ]));

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: Container(
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(widget.heading,
                              style: TextStyle(color: Color(0xFFFDFEFF))),
                        ),
                        ShakeAnimationWidget(
                          child: dots,
                          controller: controller,
                        ),
                      ],
                    )),
                flex: 1),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: passCode,
              ),
              flex: 3,
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';

class ShakeAnimationWidget extends StatefulWidget {
  ShakeAnimationWidget({this.child, @required this.controller});

  final Widget child;
  final AnimationController controller;

  @override
  _ShakeAnimationWidgetState createState() => _ShakeAnimationWidgetState();
}

class _ShakeAnimationWidgetState extends State<ShakeAnimationWidget> {
  
  Animation<Offset> _animation;
  final double offsetx = 0.6;

  @override
  void initState() {
    super.initState();
    // _controller =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(offsetx * -0.1, 0.0)),
          weight: 0.5),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(offsetx * -0.1, 0.0), end: Offset(offsetx * 0.1, 0.0)),
          weight: 1.0),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(offsetx * 0.1, 0.0), end: Offset(offsetx * -0.1, 0.0)),
          weight: 1.0),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(offsetx * -0.1, 0.0), end: Offset(offsetx * 0.1, 0.0)),
          weight: 1.0),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(offsetx * 0.1, 0.0), end: Offset(offsetx * -0.05, 0.0)),
          weight: 1.0),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(offsetx * -0.05, 0.0), end: Offset(offsetx * 0.05, 0.0)),
          weight: 1.0),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset(offsetx * 0.05, 0.0), end: Offset(0.0, 0.0)),
          weight: 0.5),
    ]).animate(CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }


  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SlideTransition(child: widget.child, position: _animation);
  }
}

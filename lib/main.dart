import 'package:flutter/material.dart';
import 'package:lockapp/pages/lock.dart';
import 'package:lockapp/components/shake_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String server = 'http://52.158.237.227:4000';
const String serialNumber = '29J0785';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lock App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  bool _locked = true;

  void initState() {
    super.initState();
    _checkLockStatus();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  animateLock() async {
    controller.reset();
    await controller.forward();
  }

  Future<http.Response> postUnlock(pin) {
    return http.post('$server/unlock?uid=1&sn=$serialNumber&pin=$pin');
  }

  unlockLock() async {
    int pin = 0;
    pin = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Lock(
                  heading: 'Enter passcode',
                  create:
                      false, // needs to be removed from this module so it's more reusible
                ),
            fullscreenDialog: true));
    if (pin > 0) {
      bool success = jsonDecode((await postUnlock(pin)).body);
      if (!success) {
        animateLock();
      } else {
        setState(() {
          _locked = false;
        });
      }
    }
  }

  Future<http.Response> getLockStatus() {
    print('$server/lock-status?sn=$serialNumber');
    return http.get('$server/lock-status?sn=$serialNumber');
  }

  _checkLockStatus() async {
    bool locked = jsonDecode((await getLockStatus()).body);
    setState(() {
      _locked = locked;
    });
  }

  Future<http.Response> postLock() {
    return http.post('$server/lock?sn=$serialNumber');
  }

  lockLock() async {
    bool locked = jsonDecode((await postLock()).body);
    setState(() {
      _locked = locked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: _locked ? Colors.red : Colors.green),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'sn: 29J0785',
              textScaleFactor: 2,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: ShakeAnimationWidget(
                child: Icon(
                  _locked ? Icons.lock : Icons.lock_open,
                  size: 200,
                  color: Colors.white,
                ),
                controller: controller,
              ),
              onTap: () => _locked ? unlockLock() : lockLock(),
            )
          ],
        ),
      ),
    ));
  }
}

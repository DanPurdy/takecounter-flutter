import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takecounter/src/counter.dart';
import 'package:takecounter/src/toggleContainer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takecounter',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          ),
      home: MyHomePage(title: 'Takecounter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final"

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOpen = false;
  bool _isCurrent = false;
  int _take = 1;
  int _pass = 1;
  bool isListening = false;

  void initState() {
    super.initState();
    if (isListening) return;

    isListening = true;

    RawKeyboard.instance.addListener(_onKey);
  }

  void dispose() {
    super.dispose();
    if (!isListening) return;

    RawKeyboard.instance.removeListener(_onKey);

    isListening = false;
  }

  void _onKey(RawKeyEvent event) async {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      if (event.isKeyPressed(LogicalKeyboardKey.keyJ)) {
        _toggleContainer();
      }
      if (event.isKeyPressed(LogicalKeyboardKey.keyP)) {
        if (!_isCurrent) {
          setState(() {
            _isCurrent = true;
          });
        } else {
          setState(() {
            _isCurrent = false;
          });
          _incrementTake();
        }
      }
      if (event.isKeyPressed(LogicalKeyboardKey.semicolon)) {
        _decrementTake();
      }
      if (event.isKeyPressed(LogicalKeyboardKey.keyO)) {
        _incrementPass();
      }
      if (event.isKeyPressed(LogicalKeyboardKey.keyL)) {
        _decrementPass();
      }
    }
  }

  void _toggleContainer() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  void _incrementTake() {
    setState(() {
      _take = min(9999, _take + 1);
    });
  }

  void _incrementPass() {
    setState(() {
      _pass = min(999, _pass + 1);
    });
  }

  void _decrementTake() {
    setState(() {
      _take = max(1, _take - 1);
    });
  }

  void _decrementPass() {
    setState(() {
      _pass = max(1, _pass - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Container(
            child: Column(children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          Row(children: [
            Visibility(
              maintainState: true,
              visible: isOpen ? true : false,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: new Column(children: [
                    new Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.45,
                      color: Colors.black,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        child: Center(
                            child: Text('Pass',
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    new Counter(
                      value: _pass,
                    )
                  ])),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              width: isOpen
                  ? MediaQuery.of(context).size.width * 0.55
                  : MediaQuery.of(context).size.width,
              child: new Column(children: [
                new Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: isOpen
                      ? MediaQuery.of(context).size.width * 0.55
                      : MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: Center(
                        child: Text('Take',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                new Counter(
                  value: _take,
                ),
              ]),
            ),
          ]),
        ]),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 3.0, color: Colors.black)),
            color: _isCurrent ? Colors.red : Colors.green),
        child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.contain,
          child: Center(
              child: Text(_isCurrent ? 'Current' : 'Next',
                  style: TextStyle(color: Colors.white))),
        ),
      ),
    ])));
  }
}

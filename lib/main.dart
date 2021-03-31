import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menubar/menubar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takecounter/src/ControlForm.dart';
import 'package:takecounter/src/dialogs/EditControlsDialog.dart';
import 'package:takecounter/src/dialogs/ResetDialog.dart';
import 'package:takecounter/src/dialogs/SelectTakeDialog.dart';
import 'package:takecounter/src/widgets/Counter.dart';

const MAX_TAKE = 9999;
const MAX_PASS = 999;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Counter',
      theme: ThemeData(fontFamily: 'Heebo'),
      home: MyHomePage(title: 'Takecounter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPassVisible = false;
  bool _isCurrent = false;
  int _take = 1;
  int _pass = 1;
  bool _isListening = false;
  bool _isDialogOpen = false;
  ControlForm controls;

  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      controls = new ControlForm(
        prefs,
      );
      _checkPreferences(prefs);
    });
  }

  void dispose() {
    super.dispose();
    if (!_isListening) return;

    RawKeyboard.instance.removeListener(_onKey);

    _isListening = false;
  }

  void _checkPreferences(SharedPreferences prefs) async {
    if (!prefs.containsKey('hasKeys') || prefs.getBool('hasKeys') == false) {
      await _showEditControls(context);
    } else {
      await controls.loadControls();

      _isListening = true;
      RawKeyboard.instance.addListener(_onKey);
    }
  }

  void _onKey(RawKeyEvent event) async {
    if (!_isDialogOpen && event.runtimeType.toString() == 'RawKeyDownEvent') {
      // Takes
      if (event.logicalKey.keyId == controls.incrementTake) {
        _incrementTake();
      }
      if (event.logicalKey.keyId == controls.decrementTake) {
        _decrementTake();
      }
      if (event.logicalKey.keyId == controls.selectTake) {
        _selectTake(context);
      }

      // Passes
      if (event.logicalKey.keyId == controls.togglePass) {
        _toggleContainer();
      }
      if (event.logicalKey.keyId == controls.incrementPass) {
        _incrementPass();
      }
      if (event.logicalKey.keyId == controls.decrementPass) {
        _decrementPass();
      }
      if (event.logicalKey.keyId == controls.initiateNewPass) {
        _initiateNewPass();
      }

      // Reset
      if (event.logicalKey.keyId == controls.reset) {
        _resetApp(context);
      }
    }
  }

  void _toggleContainer() {
    setState(() {
      _isPassVisible = !_isPassVisible;
    });
  }

  void _incrementTake() {
    setState(() {
      if (!_isCurrent) {
        _isCurrent = true;
      } else if (_take != MAX_TAKE) {
        _isCurrent = false;
        _take = min(MAX_TAKE, _take + 1);
      }
    });
  }

  void _incrementPass() {
    if (_isPassVisible) {
      setState(() {
        _pass = min(MAX_PASS, _pass + 1);
      });
    }
  }

  void _decrementTake() {
    setState(() {
      if (_isCurrent) {
        _isCurrent = false;
      } else {
        _take = max(1, _take - 1);
      }
    });
  }

  void _decrementPass() {
    if (_isPassVisible) {
      setState(() {
        _pass = max(1, _pass - 1);
      });
    }
  }

  void _initiateNewPass() {
    if (_isPassVisible && _pass < MAX_PASS) {
      _incrementPass();
      setState(() {
        _take = 1;
      });
    }
  }

  _resetToDefault() {
    setState(() {
      this._take = 1;
      this._pass = 1;
      this._isCurrent = false;
    });
  }

  Future<void> _showEditControls(BuildContext context) {
    RawKeyboard.instance.removeListener(_onKey);

    setState(() {
      _isDialogOpen = true;
      _isListening = false;
    });

    return showDialog(
        context: context,
        builder: (context) {
          return EditControlsDialog(
            controls: controls,
          );
        }).then((val) async {
      await controls.commit();
      setState(() {
        _isListening = true;
        _isDialogOpen = false;
      });

      RawKeyboard.instance.addListener(_onKey);
    });
  }

  Future<void> _selectTake(BuildContext context) {
    setState(() {
      _isDialogOpen = true;
    });
    return showDialog<int>(
        context: context,
        builder: (context) {
          return SelectTakeDialog(take: _take);
        }).then((int value) {
      setState(() {
        if (value != null) {
          this._take = min(MAX_TAKE, max(1, value));
        }

        _isDialogOpen = false;
      });
    });
  }

  Future<void> _resetApp(BuildContext context) {
    setState(() {
      _isDialogOpen = true;
    });

    return showDialog(
        context: context,
        builder: (context) {
          return ResetDialog(
            resetToDefault: _resetToDefault,
          );
        }).then((_) {
      setState(() {
        _isDialogOpen = false;
      });
    });
  }

  _updateMenu() {
    if (!Platform.isMacOS && !Platform.isLinux) {
      return;
    }

    setApplicationMenu([
      Submenu(label: 'Controls', children: [
        MenuItem(
            label: 'Edit Controls',
            enabled: true,
            onClicked: () {
              _showEditControls(context);
            }),
        MenuDivider(),
        MenuItem(
            label: 'Reset Control Defaults',
            enabled: true,
            onClicked: () async {
              await controls.resetDefaults();
            }),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _updateMenu();
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
                visible: _isPassVisible ? true : false,
                child: Row(children: [
                  Container(
                      width: (MediaQuery.of(context).size.width * 0.45) - 4.0,
                      child: new Column(children: [
                        new Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 0.45,
                          color: Colors.black,
                          child: FittedBox(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            child: Center(
                                child: Text('PASS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                        color: Colors.white))),
                          ),
                        ),
                        new Counter(
                          value: _pass,
                        )
                      ])),
                  VerticalDivider(
                    width: 4.0,
                    thickness: 4.0,
                    color: Colors.black,
                  )
                ])),
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              width: _isPassVisible
                  ? MediaQuery.of(context).size.width * 0.55
                  : MediaQuery.of(context).size.width,
              child: new Column(children: [
                new Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: _isPassVisible
                      ? MediaQuery.of(context).size.width * 0.55
                      : MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: Center(
                        child: Text('TAKE',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                                color: Colors.white))),
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
            color: _isCurrent
                ? Color.fromRGBO(209, 32, 56, 1)
                : Color.fromRGBO(0, 153, 51, 1)),
        child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.contain,
          child: Center(
              child: Text(_isCurrent ? 'CURRENT' : 'NEXT',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: Colors.white))),
        ),
      ),
    ])));
  }
}

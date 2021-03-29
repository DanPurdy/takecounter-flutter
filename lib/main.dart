import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takecounter/src/ControlForm.dart';
import 'package:takecounter/src/counter.dart';

const MAX_TAKE = 9999;
const MAX_PASS = 999;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takecounter',
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
    _checkPreferences();
  }

  void dispose() {
    super.dispose();
    if (!_isListening) return;

    RawKeyboard.instance.removeListener(_onKey);

    _isListening = false;
  }

  void _checkPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    controls = new ControlForm(
      LogicalKeyboardKey.numpadAdd.keyId,
      LogicalKeyboardKey.numpadSubtract.keyId,
      LogicalKeyboardKey.numpad6.keyId,
      LogicalKeyboardKey.numpad9.keyId,
      LogicalKeyboardKey.numpadMultiply.keyId,
      LogicalKeyboardKey.numpad4.keyId,
      LogicalKeyboardKey.numpad7.keyId,
      LogicalKeyboardKey.numpadDecimal.keyId,
      prefs,
    );

    if (!prefs.containsKey('hasKeys') || prefs.getBool('hasKeys') == false) {
      await _showEditControls(context);
      await controls.commit();
    } else {
      await controls.loadControls();

      _isListening = true;
      RawKeyboard.instance.addListener(_onKey);
    }
  }

  void _onKey(RawKeyEvent event) async {
    if (!_isDialogOpen && event.runtimeType.toString() == 'RawKeyDownEvent') {
      if (event.logicalKey.keyId == controls.togglePass) {
        _toggleContainer();
      }
      if (event.logicalKey.keyId == controls.incrementTake) {
        if (!_isCurrent) {
          setState(() {
            _isCurrent = true;
          });
        } else if (_take != MAX_TAKE) {
          setState(() {
            _isCurrent = false;
          });
          _incrementTake();
        }
      }
      if (event.logicalKey.keyId == controls.decrementTake) {
        if (_isCurrent) {
          setState(() {
            _isCurrent = false;
          });
        } else {
          _decrementTake();
        }
      }
      if (event.logicalKey.keyId == controls.incrementPass) {
        if (_isPassVisible) {
          _incrementPass();
        }
      }
      if (event.logicalKey.keyId == controls.decrementPass) {
        if (_isPassVisible) {
          _decrementPass();
        }
      }
      if (event.logicalKey.keyId == controls.reset) {
        _isDialogOpen = true;
        _resetApp(context);
      }
      if (event.logicalKey.keyId == controls.selectTake) {
        _isDialogOpen = true;
        _selectTake(context).then((int value) {
          if (value != null) {
            setState(() {
              this._take = min(MAX_TAKE, max(1, value));
            });
          }

          _isDialogOpen = false;
        });
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
      _take = min(MAX_TAKE, _take + 1);
    });
  }

  void _incrementPass() {
    setState(() {
      _pass = min(MAX_PASS, _pass + 1);
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

  Future<void> _showEditControls(BuildContext context) {
    TextEditingController _incrementTakeController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.incrementTake)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _decrementTakeController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.decrementTake)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _incrementPassController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.incrementPass)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _decrementPassController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.decrementPass)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _selectTakeController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.selectTake)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _togglePassController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.togglePass)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _initiateNewPassController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.initiateNewPass)
            .debugName
            .toString()
            .toLowerCase());
    TextEditingController _resetController = TextEditingController(
        text: LogicalKeyboardKey.findKeyByKeyId(controls.reset)
            .debugName
            .toString()
            .toLowerCase());

    RawKeyboard.instance.removeListener(_onKey);

    setState(() {
      _isListening = false;
    });

    void _handleKeyEvent(RawKeyEvent event, TextEditingController controller,
        ControlType control) {
      if (event.runtimeType.toString() == 'RawKeyUpEvent' &&
          event.logicalKey.keyLabel.toString() != '') {
        final int keyId = event.logicalKey.keyId;
        switch (control) {
          case ControlType.incrementTake:
            setState(() {
              controls.incrementTake = keyId;
            });
            break;
          case ControlType.decrementTake:
            setState(() {
              controls.decrementTake = keyId;
            });

            break;
          case ControlType.incrementPass:
            setState(() {
              controls.incrementPass = keyId;
            });
            break;
          case ControlType.decrementPass:
            setState(() {
              controls.decrementPass = keyId;
            });
            break;
          case ControlType.selectTake:
            setState(() {
              controls.selectTake = keyId;
            });
            break;
          case ControlType.togglePass:
            setState(() {
              controls.togglePass = keyId;
            });
            break;
          case ControlType.initiateNewPass:
            setState(() {
              controls.initiateNewPass = keyId;
            });
            break;
          case ControlType.reset:
            setState(() {
              controls.reset = keyId;
            });
            break;
        }

        controller.value = TextEditingValue(
            text: event.logicalKey.debugName.toString().toLowerCase());
      }
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text('Choose your controls'),
            content: SingleChildScrollView(
                child: Stack(
              children: <Widget>[
                Form(
                    child: Column(
                  children: [
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: false),
                      child: TextFormField(
                        autofocus: true,
                        decoration:
                            InputDecoration(labelText: 'Increment Take'),
                        enableInteractiveSelection: false,
                        controller: _incrementTakeController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(event,
                          _incrementTakeController, ControlType.incrementTake),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Decrement Take'),
                        enableInteractiveSelection: false,
                        controller: _decrementTakeController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(event,
                          _decrementTakeController, ControlType.decrementTake),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        validator: (val) {
                          if (val == null) {
                            return 'Value is required';
                          }
                        },
                        decoration:
                            InputDecoration(labelText: 'Increment Pass'),
                        enableInteractiveSelection: false,
                        controller: _incrementPassController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(event,
                          _incrementPassController, ControlType.incrementPass),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Decrement Pass'),
                        enableInteractiveSelection: false,
                        controller: _decrementPassController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(event,
                          _decrementPassController, ControlType.decrementPass),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Select Take'),
                        enableInteractiveSelection: false,
                        controller: _selectTakeController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(
                          event, _selectTakeController, ControlType.selectTake),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Toggle Pass View'),
                        enableInteractiveSelection: false,
                        controller: _togglePassController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(
                          event, _togglePassController, ControlType.togglePass),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Initiate New Pass'),
                        enableInteractiveSelection: false,
                        controller: _initiateNewPassController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(
                          event,
                          _initiateNewPassController,
                          ControlType.initiateNewPass),
                    ),
                    RawKeyboardListener(
                      focusNode: FocusNode(skipTraversal: true),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Reset'),
                        enableInteractiveSelection: false,
                        controller: _resetController,
                        readOnly: true,
                      ),
                      onKey: (event) => _handleKeyEvent(
                          event, _resetController, ControlType.reset),
                    ),
                  ],
                ))
              ],
            )),
          );
        }).then((val) {
      setState(() {
        _isListening = true;
      });
      RawKeyboard.instance.addListener(_onKey);
      // TODO handle this in its own widget state
      // _incrementTakeController.dispose();
      // _decrementTakeController.dispose();
      // _incrementPassController.dispose();
      // _decrementPassController.dispose();
      // _selectTakeController.dispose();
      // _togglePassController.dispose();
      // _initiateNewPassController.dispose();
      // _resetController.dispose();
    });
  }

  Future<int> _selectTake(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select take'),
            content: CupertinoTextField(
              onSubmitted: (val) {
                Navigator.of(context).pop(int.parse(
                    customController.text.isEmpty
                        ? _take.toString()
                        : customController.text.toString()));
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              controller: customController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            actions: <Widget>[
              CupertinoButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop(int.parse(
                        customController.text.isEmpty
                            ? _take.toString()
                            : customController.text.toString()));
                  })
            ],
          );
        });
  }

  _resetApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return RawKeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
                    event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
                  Navigator.of(context).pop();
                  setState(() {
                    _take = 1;
                    _pass = 1;
                    _isCurrent = false;
                  });
                }
              },
              child: AlertDialog(
                title: Text('Reset Takecounter'),
                content: Text('Reset the takecounter'),
                actions: <Widget>[
                  CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  CupertinoButton(
                      child: Text('Confirm'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _take = 1;
                          _pass = 1;
                          _isCurrent = false;
                        });
                      }),
                ],
              ));
        }).then((test) {
      _isDialogOpen = false;
    });
  }

  _updateMenu() {
    if (!Platform.isMacOS && !Platform.isLinux) {
      return;
    }
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
                      width: (MediaQuery.of(context).size.width * 0.45) - 12.0,
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
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                        new Counter(
                          value: _pass,
                        )
                      ])),
                  VerticalDivider(
                    width: 12.0,
                    thickness: 12.0,
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
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Row(children: [
                        Container(
                          width: constraints.maxWidth * 0.90,
                          height: constraints.maxHeight,
                          child: FittedBox(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            child: Center(
                                child: Text('TAKE',
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.10,
                          height: constraints.maxHeight,
                          child: IconButton(
                              onPressed: () => _showEditControls(context),
                              iconSize: 20.0,
                              icon: Icon(
                                Icons.keyboard_sharp,
                                color: Colors.white,
                              )),
                        )
                      ]);
                    })),
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
              child: Text(_isCurrent ? 'CURRENT' : 'NEXT',
                  style: TextStyle(color: Colors.white))),
        ),
      ),
    ])));
  }
}

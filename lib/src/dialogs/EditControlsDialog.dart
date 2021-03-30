import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takecounter/src/ControlForm.dart';

class EditControlsDialog extends StatefulWidget {
  final ControlForm controls;
  EditControlsDialog({Key key, @required this.controls}) : super(key: key);

  @override
  _EditControlsDialogState createState() => new _EditControlsDialogState();
}

class _EditControlsDialogState extends State<EditControlsDialog> {
  TextEditingController _incrementTakeController = TextEditingController();
  TextEditingController _decrementTakeController = TextEditingController();
  TextEditingController _incrementPassController = TextEditingController();
  TextEditingController _decrementPassController = TextEditingController();
  TextEditingController _selectTakeController = TextEditingController();
  TextEditingController _togglePassController = TextEditingController();
  TextEditingController _initiateNewPassController = TextEditingController();
  TextEditingController _resetController = TextEditingController();

  void initState() {
    super.initState();
    _incrementTakeController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.incrementTake)
            .debugName
            .toString()
            .toUpperCase());
    _decrementTakeController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.decrementTake)
            .debugName
            .toString()
            .toUpperCase());
    _incrementPassController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.incrementPass)
            .debugName
            .toString()
            .toUpperCase());
    _decrementPassController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.decrementPass)
            .debugName
            .toString()
            .toUpperCase());
    _selectTakeController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.selectTake)
            .debugName
            .toString()
            .toUpperCase());
    _togglePassController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.togglePass)
            .debugName
            .toString()
            .toUpperCase());
    _initiateNewPassController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.initiateNewPass)
            .debugName
            .toString()
            .toUpperCase());
    _resetController.value = TextEditingValue(
        text: LogicalKeyboardKey.findKeyByKeyId(widget.controls.reset)
            .debugName
            .toString()
            .toUpperCase());
  }

  void dispose() {
    super.dispose();
    _incrementTakeController.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event, TextEditingController controller,
      ControlType control) {
    if (event.runtimeType.toString() == 'RawKeyUpEvent' &&
        event.logicalKey.keyLabel.toString() != '') {
      final int keyId = event.logicalKey.keyId;
      if (keyId != null) {
        switch (control) {
          case ControlType.incrementTake:
            setState(() {
              widget.controls.incrementTake = keyId;
            });
            break;
          case ControlType.decrementTake:
            setState(() {
              widget.controls.decrementTake = keyId;
            });

            break;
          case ControlType.incrementPass:
            setState(() {
              widget.controls.incrementPass = keyId;
            });
            break;
          case ControlType.decrementPass:
            setState(() {
              widget.controls.decrementPass = keyId;
            });
            break;
          case ControlType.selectTake:
            setState(() {
              widget.controls.selectTake = keyId;
            });
            break;
          case ControlType.togglePass:
            setState(() {
              widget.controls.togglePass = keyId;
            });
            break;
          case ControlType.initiateNewPass:
            setState(() {
              widget.controls.initiateNewPass = keyId;
            });
            break;
          case ControlType.reset:
            setState(() {
              widget.controls.reset = keyId;
            });
            break;
        }
      }

      controller.value = TextEditingValue(
          text: event.logicalKey.debugName.toString().toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        CupertinoButton(
          child: Text('Reset to default'),
          onPressed: () async {
            await widget.controls.resetDefaults();
            Navigator.of(context).pop();
          },
        ),
        CupertinoButton.filled(
          child: Text('Save Preferences'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      title: Text(
        'Edit controls',
        style: TextStyle(fontSize: 24),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: CupertinoScrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Form(
                      child: Column(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10.0, 15.0, 30.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Takes',
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                                'Allows you to control the increment and decrement of takes',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.left),
                            RawKeyboardListener(
                              focusNode: FocusNode(skipTraversal: false),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: TextFormField(
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Increment Take'),
                                    enableInteractiveSelection: false,
                                    controller: _incrementTakeController,
                                    readOnly: true,
                                  )),
                              onKey: (event) => _handleKeyEvent(
                                  event,
                                  _incrementTakeController,
                                  ControlType.incrementTake),
                            ),
                            RawKeyboardListener(
                              focusNode: FocusNode(skipTraversal: true),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Decrement Take'),
                                    enableInteractiveSelection: false,
                                    controller: _decrementTakeController,
                                    readOnly: true,
                                  )),
                              onKey: (event) => _handleKeyEvent(
                                  event,
                                  _decrementTakeController,
                                  ControlType.decrementTake),
                            ),
                            RawKeyboardListener(
                              focusNode: FocusNode(skipTraversal: true),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Select Take'),
                                    enableInteractiveSelection: false,
                                    controller: _selectTakeController,
                                    readOnly: true,
                                  )),
                              onKey: (event) => _handleKeyEvent(
                                  event,
                                  _selectTakeController,
                                  ControlType.selectTake),
                            ),
                          ]),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 15.0, 30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Passes',
                                  style: TextStyle(fontSize: 22),
                                  textAlign: TextAlign.left),
                              Text(
                                  'Toggle pass view enables the pass and take mode. You can increment passes and takes independently from takes. Initiate new pass will reset take to 1 as pass increments',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  textAlign: TextAlign.left),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                              RawKeyboardListener(
                                focusNode: FocusNode(skipTraversal: true),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Toggle Pass View'),
                                      enableInteractiveSelection: false,
                                      controller: _togglePassController,
                                      readOnly: true,
                                    )),
                                onKey: (event) => _handleKeyEvent(
                                    event,
                                    _togglePassController,
                                    ControlType.togglePass),
                              ),
                              RawKeyboardListener(
                                focusNode: FocusNode(skipTraversal: true),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val == null) {
                                          return 'Value is required';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Increment Pass'),
                                      enableInteractiveSelection: false,
                                      controller: _incrementPassController,
                                      readOnly: true,
                                    )),
                                onKey: (event) => _handleKeyEvent(
                                    event,
                                    _incrementPassController,
                                    ControlType.incrementPass),
                              ),
                              RawKeyboardListener(
                                focusNode: FocusNode(skipTraversal: true),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Decrement Pass'),
                                      enableInteractiveSelection: false,
                                      controller: _decrementPassController,
                                      readOnly: true,
                                    )),
                                onKey: (event) => _handleKeyEvent(
                                    event,
                                    _decrementPassController,
                                    ControlType.decrementPass),
                              ),
                              RawKeyboardListener(
                                focusNode: FocusNode(skipTraversal: true),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Initiate New Pass'),
                                      enableInteractiveSelection: false,
                                      controller: _initiateNewPassController,
                                      readOnly: true,
                                    )),
                                onKey: (event) => _handleKeyEvent(
                                    event,
                                    _initiateNewPassController,
                                    ControlType.initiateNewPass),
                              )
                            ])),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 15.0, 30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reset',
                                  style: TextStyle(fontSize: 22),
                                  textAlign: TextAlign.left),
                              Text(
                                  'Lets you reset the take counter back to take 1, pass 1',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  textAlign: TextAlign.left),
                              RawKeyboardListener(
                                focusNode: FocusNode(skipTraversal: true),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Reset',
                                      ),
                                      enableInteractiveSelection: false,
                                      controller: _resetController,
                                      readOnly: true,
                                    )),
                                onKey: (event) => _handleKeyEvent(
                                    event, _resetController, ControlType.reset),
                              ),
                            ])),
                  ]))
                ],
              ),
            )),
      ),
    );
  }
}

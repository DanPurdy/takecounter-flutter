import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetDialog extends StatefulWidget {
  final void Function() resetToDefault;
  ResetDialog({Key key, @required this.resetToDefault}) : super(key: key);

  @override
  _ResetDialogState createState() => new _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
              event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
            widget.resetToDefault();
            Navigator.of(context).pop();
          }
        },
        child: AlertDialog(
          title: Text('Reset Takecounter'),
          actions: <Widget>[
            CupertinoButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoButton.filled(
                child: Text('Confirm'),
                onPressed: () {
                  widget.resetToDefault();
                  Navigator.of(context).pop();
                }),
          ],
        ));
  }
}

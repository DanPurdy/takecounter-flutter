import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectTakeDialog extends StatefulWidget {
  final int take;
  SelectTakeDialog({Key key, @required this.take}) : super(key: key);

  @override
  _SelectTakeDialogState createState() => new _SelectTakeDialogState();
}

class _SelectTakeDialogState extends State<SelectTakeDialog> {
  TextEditingController _takeSelectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select take'),
      content: CupertinoTextField(
        onSubmitted: (val) {
          Navigator.of(context).pop(int.parse(_takeSelectController.text.isEmpty
              ? widget.take.toString()
              : _takeSelectController.text.toString()));
        },
        autofocus: true,
        keyboardType: TextInputType.number,
        controller: _takeSelectController,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
      actions: <Widget>[
        CupertinoButton(
            child: Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(int.parse(
                  _takeSelectController.text.isEmpty
                      ? widget.take.toString()
                      : _takeSelectController.text.toString()));
            })
      ],
    );
  }
}

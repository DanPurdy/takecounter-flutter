import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takecounter/src/ControlForm.dart';
import 'package:takecounter/src/widgets/ControlCard.dart';
import 'package:takecounter/src/widgets/ControlListTile.dart';

class ControlSwitchDialog extends StatefulWidget {
  final ControlForm controls;
  ControlSwitchDialog({Key key, @required this.controls}) : super(key: key);

  @override
  _ControlSwitchDialogState createState() => new _ControlSwitchDialogState();
}

class _ControlSwitchDialogState extends State<ControlSwitchDialog> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return AlertDialog(
          backgroundColor: Color.fromRGBO(232, 232, 232, 1),
          actions: [
            CupertinoButton.filled(
                child: Text('Continue'),
                onPressed: () => Navigator.of(context).pop()),
          ],
          content: Container(
              width: min(MediaQuery.of(context).size.width * 0.8, 1000),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: CupertinoScrollbar(
                      child: SingleChildScrollView(
                          child: Container(
                              width: constraints.maxWidth,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 15, 30),
                                        width: constraints.maxWidth,
                                        child: Material(
                                            type: MaterialType.card,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            color: Colors.white,
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 40, 10, 40),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Controls',
                                                        style: TextStyle(
                                                            fontSize: 24),
                                                      ),
                                                      Text(
                                                        'The take-counter can be controlled by using either your trackpad or your keyboard, ',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ])))),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    ControlListTile(
                                                        keyId: 'T1',
                                                        title: 'Increment Take',
                                                        description:
                                                            'Increment the take value'),
                                                    ControlListTile(
                                                        keyId: 'T2',
                                                        title: 'Decrement Take',
                                                        description:
                                                            'Decrement the take value'),
                                                    ControlListTile(
                                                        keyId: 'T3',
                                                        title: 'Select Take',
                                                        description:
                                                            'Open the select take dialog'),
                                                    Divider(height: 10),
                                                    ControlListTile(
                                                        keyId: 'P1',
                                                        title: 'Increment Pass',
                                                        description:
                                                            'Increment the pass value'),
                                                    ControlListTile(
                                                        keyId: 'P2',
                                                        title: 'Decrement Pass',
                                                        description:
                                                            'Decrement the pass value'),
                                                    ControlListTile(
                                                        keyId: 'P3',
                                                        title:
                                                            'Toggle pass mode',
                                                        description:
                                                            'Enable/Disable the pass mode (default: disabled)'),
                                                    ControlListTile(
                                                        keyId: 'P4',
                                                        title:
                                                            'Initiate New Pass',
                                                        description:
                                                            'Icrements the pass value and resets the take count to 1'),
                                                    Divider(height: 10),
                                                    ControlListTile(
                                                        keyId: 'R',
                                                        title: 'Reset',
                                                        description:
                                                            'Reset the take value and pass value to 1')
                                                  ])),
                                          ControlCard(
                                              imageUrl:
                                                  'assets/images/KeypadFullVertical.png',
                                              title: 'Controls'),
                                        ]),
                                  ])))))));
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlListTile extends StatelessWidget {
  final String keyId;
  final String title;
  final String description;
  ControlListTile({
    @required this.keyId,
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: ListTile(
          tileColor: Colors.white,
          leading: Container(
              width: 30,
              height: 30,
              color: Color.fromRGBO(73, 84, 100, 1),
              child: Center(
                  child: Text(this.keyId,
                      style: TextStyle(
                        color: Colors.white,
                      )))),
          title: Text(this.title),
          subtitle: Text(this.description),
        ));
  }
}

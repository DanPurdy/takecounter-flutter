import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  ControlCard({@required this.imageUrl, @required this.title});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(imageUrl),
          ),
        ));
  }
}

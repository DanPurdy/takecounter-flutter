import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final value;

  Counter({Key key, @required this.value}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: Container(
        child: FittedBox(
            fit: BoxFit.contain,
            child: Center(
              child: Text(widget.value.toString(),
                  style: TextStyle(color: Colors.black)),
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToggleContainer extends StatefulWidget {
  final Widget persistentElement;
  final Widget toggleElement;
  final LogicalKeyboardKey toggleKey;

  ToggleContainer(
      {Key key,
      @required this.toggleElement,
      @required this.persistentElement,
      @required this.toggleKey})
      : super(key: key);

  @override
  _ToggleContainerState createState() => _ToggleContainerState();
}

class _ToggleContainerState extends State<ToggleContainer> {
  bool isOpen = false;
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

  void _onKey(RawKeyEvent event) {
    if (event.isKeyPressed(widget.toggleKey)) {
      _toggleContainer();
    }
  }

  void _toggleContainer() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isOpen ? true : false,
        maintainState: true,
        child: new Container());
  }
}

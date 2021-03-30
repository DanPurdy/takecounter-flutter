import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ControlType {
  incrementTake,
  decrementTake,
  incrementPass,
  decrementPass,
  selectTake,
  togglePass,
  initiateNewPass,
  reset,
}

class ControlForm {
  int incrementTake = LogicalKeyboardKey.numpadAdd.keyId;
  int decrementTake = LogicalKeyboardKey.numpadSubtract.keyId;
  int incrementPass = LogicalKeyboardKey.numpad6.keyId;
  int decrementPass = LogicalKeyboardKey.numpad9.keyId;
  int selectTake = LogicalKeyboardKey.numpadMultiply.keyId;
  int togglePass = LogicalKeyboardKey.numpad4.keyId;
  int initiateNewPass = LogicalKeyboardKey.numpad7.keyId;
  int reset = LogicalKeyboardKey.numpadDecimal.keyId;
  SharedPreferences prefs;

  Future<void> commit() async {
    // TODO use a futures.wait and iterate the ControlType enum - can you do this for class props in dart?
    // TODO use setters for each property to write it to prefs?
    await prefs.setInt(
        ControlType.incrementTake.toString(), this.incrementTake);
    await prefs.setInt(
        ControlType.decrementTake.toString(), this.decrementTake);
    await prefs.setInt(
        ControlType.incrementPass.toString(), this.incrementPass);
    await prefs.setInt(
        ControlType.decrementPass.toString(), this.decrementPass);
    await prefs.setInt(ControlType.selectTake.toString(), this.selectTake);
    await prefs.setInt(ControlType.togglePass.toString(), this.togglePass);
    await prefs.setInt(
        ControlType.initiateNewPass.toString(), this.initiateNewPass);
    await prefs.setInt(ControlType.reset.toString(), this.reset);

    await prefs.setBool('hasKeys', true);
  }

  Future<void> loadControls() async {
    if (prefs.containsKey(ControlType.incrementTake.toString())) {
      this.incrementTake = prefs.getInt(ControlType.incrementTake.toString());
    }
    if (prefs.containsKey(ControlType.decrementTake.toString())) {
      this.decrementTake = prefs.getInt(ControlType.decrementTake.toString());
    }
    if (prefs.containsKey(ControlType.incrementPass.toString())) {
      this.incrementPass = prefs.getInt(ControlType.incrementPass.toString());
    }
    if (prefs.containsKey(ControlType.decrementPass.toString())) {
      this.decrementPass = prefs.getInt(ControlType.decrementPass.toString());
    }
    if (prefs.containsKey(ControlType.selectTake.toString())) {
      this.selectTake = prefs.getInt(ControlType.selectTake.toString());
    }
    if (prefs.containsKey(ControlType.togglePass.toString())) {
      this.togglePass = prefs.getInt(ControlType.togglePass.toString());
    }
    if (prefs.containsKey(ControlType.initiateNewPass.toString())) {
      this.initiateNewPass =
          prefs.getInt(ControlType.initiateNewPass.toString());
    }
    if (prefs.containsKey(ControlType.reset.toString())) {
      this.reset = prefs.getInt(ControlType.reset.toString());
    }
  }

  resetDefaults() async {
    this.incrementTake = LogicalKeyboardKey.numpadAdd.keyId;
    this.decrementTake = LogicalKeyboardKey.numpadSubtract.keyId;
    this.incrementPass = LogicalKeyboardKey.numpad6.keyId;
    this.decrementPass = LogicalKeyboardKey.numpad9.keyId;
    this.selectTake = LogicalKeyboardKey.numpadMultiply.keyId;
    this.togglePass = LogicalKeyboardKey.numpad4.keyId;
    this.initiateNewPass = LogicalKeyboardKey.numpad7.keyId;
    this.reset = LogicalKeyboardKey.numpadDecimal.keyId;

    await this.commit();
  }

  ControlForm(
    SharedPreferences prefs,
  ) {
    this.prefs = prefs;
  }
}

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
  int incrementTake;
  int decrementTake;
  int incrementPass;
  int decrementPass;
  int selectTake;
  int togglePass;
  int initiateNewPass;
  int reset;
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

  ControlForm(
    int incrementTake,
    int decrementTake,
    int incrementPass,
    int decrementPass,
    int selectTake,
    int togglePass,
    int initiateNewPass,
    int reset,
    SharedPreferences prefs,
  ) {
    this.incrementTake = incrementTake;
    this.decrementTake = decrementTake;
    this.incrementPass = incrementPass;
    this.decrementPass = decrementPass;
    this.selectTake = selectTake;
    this.togglePass = togglePass;
    this.initiateNewPass = initiateNewPass;
    this.reset = reset;
    this.prefs = prefs;
  }
}

import 'package:flutter/material.dart';

class ValidationNotifier {
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  void schoolSetupDone({required bool isDone}) {
    valueNotifier.addListener(() => isDone);
  }
}

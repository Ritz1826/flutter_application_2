import 'dart:async';

import 'package:flutter/material.dart';

class DebounceHelper {
  Timer? _timer;

  void callFunction(VoidCallback callBack) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 500), callBack);
  }

  void timerDispose() {
    _timer?.cancel();
  }
}

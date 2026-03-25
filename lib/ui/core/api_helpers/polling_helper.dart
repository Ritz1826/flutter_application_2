import 'dart:async';

import 'package:flutter/material.dart';

class PollingHelper {
  final Duration interval;
  final Future<void> Function() function;
  final ScrollController? scroller;

  PollingHelper({
    required this.interval,
    required this.function,
    this.scroller,
  });

  Timer? _timer;
  bool _isRunning = false;
  bool _isFetching = false;
  int _callNo = 1;

  void startPolling() {
    if (_isRunning) return;

    _isRunning = true;

    _timer = Timer.periodic(interval, (_) {
      if (_isFetching) return;
      _isFetching = true;

      try {
        if (scroller != null && _callNo > 1) {
          print("calleddddd");
          scroller!.animateTo(
            scroller!.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.bounceIn,
          );
        }
        _callNo++;
        function.call();
      } finally {
        _isFetching = false;
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _isFetching = false;
    _isRunning = false;
  }
}

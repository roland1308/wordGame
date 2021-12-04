import 'dart:async';

import 'package:flutter/material.dart';

class ClockProvider extends ChangeNotifier {
  Timer? _timerGame;
  int _remainingSeconds = 0;

  get remainingSeconds => _remainingSeconds;

  void startClock(int seconds) {
    _remainingSeconds = seconds;
    if (_timerGame != null && _timerGame!.isActive) {
      stopClock();
    }
    _timerGame = Timer.periodic(Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds == 0) {
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void stopClock() {
    _timerGame?.cancel();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_game/providers/clock_provider.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var seconds = Provider.of<ClockProvider>(context).remainingSeconds;
    return Text(seconds.toString());
  }
}
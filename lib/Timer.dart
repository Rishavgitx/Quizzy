import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final VoidCallback showNextQuestionCallback;

  TimerWidget({required this.showNextQuestionCallback});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _countdown = 30; // Set the initial countdown value

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          widget.showNextQuestionCallback();
          resetTimer(); // Reset the timer for the next question
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      _countdown = 30;
    });
    startTimer(); // Start the timer again for the next question
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_countdown',
      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
    );
  }
}

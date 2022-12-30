import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class TimerButtonWidget extends StatefulWidget {
  final Function onTimerFinished;
  const TimerButtonWidget({Key? key, required this.onTimerFinished})
      : super(key: key);

  @override
  State<TimerButtonWidget> createState() => _TimerButtonWidgetState();
}

class _TimerButtonWidgetState extends State<TimerButtonWidget> {
  late Timer _timer;
  int _start = 30;

  void _startTimer() {
    var oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTimerFinished();
        _startTimer();
      },
      child: Container(
        // height: 50,
        width: MediaQuery.of(context).size.width * 0.6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: kColorWhite,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Text('Resend $_start'),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

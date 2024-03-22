import 'package:flutter/material.dart';

enum Activity {
  wakeUp,
  gym,
  breakfast,
  meeting,
  lunch,
  quickNap,
  library,
  sleep,
}

class Reminder {
  const Reminder({
    required this.title,
    required this.targetTime,
    required this.activity,
  });

  final String title;
  final TimeOfDay targetTime;
  final Activity activity;
}

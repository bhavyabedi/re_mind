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

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Reminder {
  const Reminder({
    required this.day,
    required this.targetTime,
    required this.activity,
  });

  final Day day;
  final TimeOfDay targetTime;
  final Activity activity;
}

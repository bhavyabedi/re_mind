// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_mind/object_classes/reminder.dart';
import 'package:re_mind/providers/reminder.dart';

class NewReminderScreen extends ConsumerStatefulWidget {
  const NewReminderScreen({super.key});

  @override
  ConsumerState<NewReminderScreen> createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends ConsumerState<NewReminderScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  var isTimeSelected = false;
  Day? selectedDay;
  Activity? selectedActivity;
  void _saveReminder(Reminder newReminder) {
    ref
        .read(reminderProvider.notifier)
        .addReminder(selectedDay!, selectedTime, selectedActivity!);

    Navigator.of(context).pop();
  }

  void _getTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    selectedTime = pickedTime!;
    setState(() {
      isTimeSelected = true;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Scheduled for ${(selectedTime.toString()).substring(10, 15)}'),
      ),
    );
  }

  void _validateSubmit() {
    if (selectedDay == null ||
        selectedTime == TimeOfDay.now() ||
        selectedActivity == null) {
      // print(selectedTitle);
      // print(selectedActivity);
      // print(selectedTime);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('One of the entries in Empty or Invalid'),
        ),
      );
      return;
    }
    _saveReminder(
      Reminder(
          day: selectedDay!,
          targetTime: selectedTime,
          activity: selectedActivity!),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add a Reminder:',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                      label: Text(
                    'Select Day',
                  )),
                  items: Day.values
                      .map(
                        (Day day) => DropdownMenuItem<Day>(
                          value: day,
                          child: Text(
                            day.name.toString().toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedDay = value;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _getTime();
                      },
                      icon: const Icon(
                        Icons.alarm_add_outlined,
                        color: Colors.white,
                      ),
                      label: isTimeSelected
                          ? Text(
                              (selectedTime.toString()).substring(10, 15),
                            )
                          : const Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          label: Text('Select Activity'),
                        ),
                        items: Activity.values
                            .map(
                              (Activity activity) => DropdownMenuItem<Activity>(
                                value: activity,
                                child: Text(
                                  activity.name.toString().toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          selectedActivity = value;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _validateSubmit,
                      child: const Text('Submit'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

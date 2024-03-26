import 'package:flutter/material.dart';
import 'package:re_mind/object_classes/reminder.dart';
import 'package:re_mind/widgets/reminder_list.dart';

class DayList extends StatelessWidget {
  DayList({
    super.key,
    required this.reminders,
  });
  final List<Reminder> reminders;
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thurday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    List<Reminder> sortedReminder;
    Widget body = days.isEmpty
        ? const Center(
            child: Text('No Reminders Stored...'),
          )
        : ListView.builder(
            itemCount: days.length,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
              ),
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ListTile(
                onTap: () {
                  sortedReminder = reminders
                      .where((element) =>
                          element.day.toString().toLowerCase() ==
                          "Day.${days[index]}".toLowerCase())
                      .toList();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReminderList(
                      reminders: sortedReminder,
                      day: days[index],
                    ),
                  ));
                },
                title: Text(
                  days[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
          );
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: body);
  }
}

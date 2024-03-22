import 'package:flutter/material.dart';
import 'package:re_mind/object_classes/reminder.dart';

class ReminderList extends StatelessWidget {
  ReminderList({
    super.key,
    required this.reminders,
  });

  final List<Reminder> reminders;
  final listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget body = reminders.isEmpty
        ? const Center(
            child: Text('No Reminders Stored...'),
          )
        : Dismissible(
            key: listKey,
            onDismissed: (direction) {},
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) => ListTile(
                focusColor: Colors.amber,
                title: Row(
                  children: [
                    Text(
                      reminders[index].title,
                    ),
                    const Spacer(),
                    Text(
                      reminders[index]
                          .activity
                          .toString()
                          .substring(9)
                          .toUpperCase(),
                    ),
                  ],
                ),
                subtitle: Text(
                  'For : ${reminders[index].targetTime.toString().substring(10, 15)}',
                ),
              ),
            ),
          );
    return body;
  }
}

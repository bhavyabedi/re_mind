import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_mind/object_classes/reminder.dart';

class ReminderList extends ConsumerStatefulWidget {
  const ReminderList({
    super.key,
    required this.reminders,
    required this.day,
  });
  final String day;
  final List<Reminder> reminders;

  @override
  ConsumerState<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends ConsumerState<ReminderList> {
  @override
  Widget build(BuildContext context) {
    Widget body = widget.reminders.isEmpty
        ? const Center(
            child: Text('No Reminders Stored...'),
          )
        : ListView.builder(
            itemCount: widget.reminders.length,
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey(index),
              onDismissed: (direction) {},
              background: Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: const Row(children: [
                  Spacer(),
                  Icon(Icons.delete_forever_outlined),
                  SizedBox(
                    width: 10,
                  )
                ]),
              ),
              child: ListTile(
                focusColor: Colors.amber,
                title: Row(
                  children: [
                    Text(
                      widget.reminders[index].day
                          .toString()
                          .substring(4)
                          .toUpperCase(),
                    ),
                    const Spacer(),
                    Text(
                      widget.reminders[index].activity.toString().substring(9),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                subtitle: Text(
                  'For : ${widget.reminders[index].targetTime.toString().substring(10, 15)}',
                ),
              ),
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders for ${widget.day}'),
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
          )),
          child: body),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_mind/providers/reminder.dart';
import 'package:re_mind/screens/new_reminder.dart';
import 'package:re_mind/services/notification.dart';
import 'package:re_mind/widgets/day_list.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  late Future<void> _remindersFuture;
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    notificationService.intializeNotifications();
    _remindersFuture = ref.read(reminderProvider.notifier).loadReminders();
    super.initState();
  }

  @override
  void dispose() {
    ref.read(reminderProvider.notifier).closeDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userReminders = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Days',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      ),
      body: FutureBuilder(
        future: _remindersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return DayList(
              reminders: userReminders,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
        onPressed: () {
          notificationService.sendNotification();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NewReminderScreen(),
            ),
          );
        },
      ),
    );
  }
}

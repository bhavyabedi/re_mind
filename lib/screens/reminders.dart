import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_mind/providers/reminder.dart';
import 'package:re_mind/screens/new_reminder.dart';
import 'package:re_mind/widgets/reminder_list.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  late Future<void> _remindersFuture;

  @override
  void initState() {
    super.initState();
    _remindersFuture = ref.read(reminderProvider.notifier).loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    final userReminders = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: FutureBuilder(
        future: _remindersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ReminderList(
              reminders: userReminders,
            );
          }
        },
      ),
      bottomNavigationBar: IconButton(
        padding: const EdgeInsets.only(bottom: 24, right: 24),
        alignment: Alignment.bottomRight,
        icon: const Icon(
          Icons.add_circle_outline_sharp,
          size: 45,
        ),
        onPressed: () {
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

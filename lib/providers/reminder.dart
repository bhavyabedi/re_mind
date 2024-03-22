import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:re_mind/object_classes/reminder.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  ReminderNotifier() : super(const []);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(
        dbPath,
        'reminder.db',
      ),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE userReminders(title TEXT, targetTime TEXT, activity TEXT)',
        );
      },
      version: 1,
    );
    return db;
  }

  Activity enumFromString(String value) {
    return Activity.values.firstWhere(
      (e) => e.toString().split('.').last == value,
    );
  }

  Future<void> loadReminders() async {
    final db = await _getDatabase();
    final data = await db.query('userReminders');
    final reminders = data
        .map(
          (row) => Reminder(
            title: row['title'] as String,
            targetTime: TimeOfDay.fromDateTime(
              DateTime.parse(
                row['targetTime'].toString(),
              ),
            ),
            activity: enumFromString(row['activity'].toString()),
          ),
        )
        .toList();
    state = reminders;
    // print(reminders);
  }

  void addReminder(String title, TimeOfDay time, Activity activity) async {
    // final appDir = await syspath.getApplicationCacheDirectory();
    final db = await _getDatabase();
    final newReminder =
        Reminder(title: title, targetTime: time, activity: activity);
    print(newReminder);
    try {
      await db.insert('userReminders', {
        'title': title,
        'targetTime': time.toString(),
        'activity': activity.toString(),
      });
      state = [
        newReminder,
        ...state,
      ];
    } catch (e) {
      // ignore: avoid_print
      print('Error inserting reminder: $e');
    }
  }
}

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, List<Reminder>>(
        (ref) => ReminderNotifier());

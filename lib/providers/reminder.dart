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
      onCreate: (db, version) async {
        return await db.execute(
          'CREATE TABLE userReminders(day TEXT, targetTime TEXT, activity TEXT)',
        );
      },
      version: 1,
    );
    print(db.path);
    return db;
  }

  // Activity enumFromString(String value) {
  //   return Activity.values.firstWhere(
  //     (e) => e.toString().split('.').last == value,
  //   );
  // }

  // TimeOfDay stringToTimeOfDay(String tod) {
  //   final format = DateFormat.jm(); //"6:00 AM"
  //   return TimeOfDay.fromDateTime(format.parse(tod));
  // }

  Future<void> loadReminders() async {
    final db = await _getDatabase();
    final data = await db.rawQuery('SELECT * FROM userReminders');

    print(data);
    final dataList = data.toList();
    List<Reminder> reminders = [];
    reminders = data
        .map(
          (row) => Reminder(
            day: row['day'] as Day,
            targetTime: row['targetTime'] as TimeOfDay,
            activity: row['activity'] as Activity,
          ),
        )
        .toList();
    print(data.isEmpty);
    state = reminders;
  }

  Future closeDB() async {
    final db = await _getDatabase();
    db.close();
  }

  void addReminder(Day day, TimeOfDay time, Activity activity) async {
    // final appDir = await syspath.getApplicationCacheDirectory();
    final db = await _getDatabase();
    final newReminder =
        Reminder(day: day, targetTime: time, activity: activity);
    try {
      await db.rawInsert(
          'INSERT INTO userReminders(day , targetTime, activity) VALUES("${day.toString()}", "${time.toString()}", "${activity.toString()}")');
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

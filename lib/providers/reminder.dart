import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return db;
  }

  Day dayFromString(String value) {
    return Day.values.firstWhere(
      (e) => e.toString() == value,
    );
  }

  Activity activityFromString(String value) {
    return Activity.values.firstWhere(
      (e) => e.toString() == value,
    );
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.Hm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  Future<void> loadReminders() async {
    final db = await _getDatabase();
    final data = await db.query('userReminders');
    List<Reminder> reminders = [];
    try {
      reminders = data
          .map(
            (row) => Reminder(
              day: dayFromString(data[0]['day'].toString()),
              targetTime: stringToTimeOfDay(data[0]['targetTime'].toString()),
              activity: activityFromString(data[0]['activity'].toString()),
            ),
          )
          .toList();

      state = reminders;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future closeDB() async {
    final db = await _getDatabase();
    db.close();
  }

  void addReminder(Day day, TimeOfDay time, Activity activity) async {
    final db = await _getDatabase();
    final newReminder =
        Reminder(day: day, targetTime: time, activity: activity);
    try {
      await db.rawInsert(
          'INSERT INTO userReminders(day , targetTime, activity) VALUES("${day.toString()}", "${time.toString().substring(10, 15)}", "${activity.toString()}")');

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

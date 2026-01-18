import 'package:hive_flutter/hive_flutter.dart';
import '../models/reminder.dart';
import '../services/notification_service.dart';

class ReminderRepository {
  static const String remindersBoxName = 'reminders_box';

  final NotificationService notificationService;

  ReminderRepository({required this.notificationService});

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(remindersBoxName);
  }

  Box get _box => Hive.box(remindersBoxName);

  List<Reminder> getReminders() {
    final reminders = <Reminder>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value is Map) {
        reminders.add(Reminder.fromMap(key as int, value));
      }
    }
    reminders.sort((a, b) {
      if (a.hour != b.hour) {
        return a.hour.compareTo(b.hour);
      }
      return a.minute.compareTo(b.minute);
    });
    return reminders;
  }

  Future<Reminder> addReminder(Reminder reminder) async {
    final map = reminder.toMap();
    final key = await _box.add(map);
    final stored = reminder.copyWith(id: key as int);
    if (stored.isActive) {
      await notificationService.scheduleReminder(stored);
    }
    return stored;
  }

  Future<Reminder> updateReminder(Reminder reminder) async {
    if (reminder.id == null) {
      return reminder;
    }
    await _box.put(reminder.id, reminder.toMap());
    await notificationService.cancelReminder(reminder.id!);
    if (reminder.isActive) {
      await notificationService.scheduleReminder(reminder);
    }
    return reminder;
  }

  Future<void> deleteReminder(Reminder reminder) async {
    final id = reminder.id;
    if (id == null) {
      return;
    }
    await _box.delete(id);
    await notificationService.cancelReminder(id);
  }
}


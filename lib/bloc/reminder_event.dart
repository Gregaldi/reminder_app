import 'package:equatable/equatable.dart';
import '../models/reminder.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

class LoadReminders extends ReminderEvent {}

class AddReminderEvent extends ReminderEvent {
  final Reminder reminder;

  const AddReminderEvent(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

class UpdateReminderEvent extends ReminderEvent {
  final Reminder reminder;

  const UpdateReminderEvent(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

class DeleteReminderEvent extends ReminderEvent {
  final Reminder reminder;

  const DeleteReminderEvent(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

class ToggleReminderActiveEvent extends ReminderEvent {
  final Reminder reminder;
  final bool isActive;

  const ToggleReminderActiveEvent(this.reminder, this.isActive);

  @override
  List<Object?> get props => [reminder, isActive];
}


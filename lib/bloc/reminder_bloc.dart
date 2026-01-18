import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/reminder_repository.dart';
import '../models/reminder.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository repository;

  ReminderBloc({required this.repository}) : super(ReminderInitial()) {
    on<LoadReminders>(_onLoadReminders);
    on<AddReminderEvent>(_onAddReminder);
    on<UpdateReminderEvent>(_onUpdateReminder);
    on<DeleteReminderEvent>(_onDeleteReminder);
    on<ToggleReminderActiveEvent>(_onToggleActive);
  }

  Future<void> _onLoadReminders(
    LoadReminders event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      final reminders = repository.getReminders();
      emit(ReminderLoaded(reminders));
    } catch (_) {
      emit(const ReminderError('Failed to load reminders'));
    }
  }

  Future<void> _onAddReminder(
    AddReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final currentState = state;
    if (currentState is ReminderLoaded) {
      final stored = await repository.addReminder(event.reminder);
      final updated = List<Reminder>.from(currentState.reminders)..add(stored);
      updated.sort((a, b) {
        if (a.hour != b.hour) {
          return a.hour.compareTo(b.hour);
        }
        return a.minute.compareTo(b.minute);
      });
      emit(ReminderLoaded(updated));
    }
  }

  Future<void> _onUpdateReminder(
    UpdateReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final currentState = state;
    if (currentState is ReminderLoaded) {
      final updatedReminder = await repository.updateReminder(event.reminder);
      final updated = currentState.reminders
          .map((r) => r.id == updatedReminder.id ? updatedReminder : r)
          .toList();
      updated.sort((a, b) {
        if (a.hour != b.hour) {
          return a.hour.compareTo(b.hour);
        }
        return a.minute.compareTo(b.minute);
      });
      emit(ReminderLoaded(updated));
    }
  }

  Future<void> _onDeleteReminder(
    DeleteReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final currentState = state;
    if (currentState is ReminderLoaded) {
      await repository.deleteReminder(event.reminder);
      final updated =
          currentState.reminders.where((r) => r.id != event.reminder.id).toList();
      emit(ReminderLoaded(updated));
    }
  }

  Future<void> _onToggleActive(
    ToggleReminderActiveEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final currentState = state;
    if (currentState is ReminderLoaded) {
      final updatedReminder =
          event.reminder.copyWith(isActive: event.isActive);
      final stored = await repository.updateReminder(updatedReminder);
      final updated = currentState.reminders
          .map((r) => r.id == stored.id ? stored : r)
          .toList();
      emit(ReminderLoaded(updated));
    }
  }
}


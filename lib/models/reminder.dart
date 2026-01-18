import 'package:flutter/material.dart';

class Reminder {
  final int? id;
  final String title;
  final int hour;
  final int minute;
  final bool isActive;

  const Reminder({
    this.id,
    required this.title,
    required this.hour,
    required this.minute,
    required this.isActive,
  });

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  Reminder copyWith({
    int? id,
    String? title,
    int? hour,
    int? minute,
    bool? isActive,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'hour': hour,
      'minute': minute,
      'isActive': isActive,
    };
  }

  factory Reminder.fromMap(int id, Map<dynamic, dynamic> map) {
    return Reminder(
      id: id,
      title: map['title'] as String? ?? '',
      hour: map['hour'] as int? ?? 0,
      minute: map['minute'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}


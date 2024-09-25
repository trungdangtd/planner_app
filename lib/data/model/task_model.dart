import 'package:flutter/material.dart';

class TaskModel {
  final int? id; // Task ID (nullable since it will be auto-generated)
  final String name; // Task name
  final DateTime date; // Task date
  final String content; // Task content
  final TimeOfDay startTime; // Task start time
  final TimeOfDay endTime; // Task end time
  final String location; // Task location
  final String leader; // Task leader
  final String notes;
  final String status;
  final int userId; // Additional notes

  TaskModel({
    this.id,
    required this.name,
    required this.date,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.leader,
    required this.notes,
    required this.status,
    required this.userId,
  });

  // Convert a TaskModel object into a Map object for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'content': content,
      'startTime': _timeOfDayToString(startTime),
      'endTime': _timeOfDayToString(endTime),
      'location': location,
      'leader': leader,
      'notes': notes,
      'status': status,
      'userId': userId,
    };
  }

  // Create a TaskModel object from a Map object (useful for retrieving data from the database)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      content: map['content'],
      startTime: _stringToTimeOfDay(map['startTime']),
      endTime: _stringToTimeOfDay(map['endTime']),
      location: map['location'],
      leader: map['leader'],
      notes: map['notes'],
      status: map['status'],
      userId: map['userId'],
    );
  }

  // Helper method to convert TimeOfDay to String for database storage
  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  // Helper method to convert String to TimeOfDay when retrieving from the database
  static TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

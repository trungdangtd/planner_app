import 'package:flutter/material.dart';

class TaskModel {
  final int? id; 
  final String name; 
  final DateTime date; 
  final String content; 
  final TimeOfDay startTime; 
  final TimeOfDay endTime; 
  final String location; 
  final String leader; 
  final String notes;
  final String status;
  final int userId; 

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

  
  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

 
  static TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

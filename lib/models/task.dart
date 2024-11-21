import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  DateTime deadline;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    this.isCompleted = false,
  });

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'],
      deadline: (data['deadline'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline,
      'isCompleted': isCompleted,
    };
  }
}

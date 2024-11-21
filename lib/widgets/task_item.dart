import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text('Deadline: ${task.deadline.toLocal()}'),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          // Handle task completion
        },
      ),
    );
  }
}

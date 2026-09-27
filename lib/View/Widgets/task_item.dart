import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_counter_app/Model/task.dart';
import 'package:my_counter_app/Provider/task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        // الضغط على التايتل للعلامة الصحية (Check/Uncheck)
        onTap: () {
          context.read<TaskProvider>().toggleTask(index);
        },
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: task.isDone ? Colors.pink.shade100 : Colors.pink.shade50,
          child: Icon(
            task.isDone ? Icons.check_circle : Icons.circle_outlined,
            color: task.isDone ? Colors.pink : Colors.pink.shade300,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : null,
          ),
        ),
        subtitle: task.desc.isNotEmpty ? Text(task.desc) : null,
        // أزرار التعديل والحذف
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
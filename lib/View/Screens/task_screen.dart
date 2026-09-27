import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_counter_app/Model/task.dart';
import 'package:my_counter_app/Provider/task_provider.dart';
import 'package:my_counter_app/View/Widgets/task_item.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  void _showTaskDialog(BuildContext context, {Task? task, int? index}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descController = TextEditingController(text: task?.desc ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(task == null ? 'Add New Task' : 'Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final desc = descController.text.trim();

              if (title.isNotEmpty) {
                final provider = context.read<TaskProvider>();
                if (task == null) {
                  provider.addTask(title, desc);
                } else if (index != null) {
                  provider.editTask(index, title, desc);
                }
                Navigator.pop(ctx);
              }
            },
            child: Text(task == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks List'),
        actions: [
          IconButton(
            icon: Icon(
              taskProvider.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              taskProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: taskProvider.tasks.isEmpty
          ? const Center(
              child: Text(
                'No Tasks Yet !',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return TaskItem(
                  task: task,
                  index: index,
                  onEdit: () => _showTaskDialog(context, task: task, index: index),
                  onDelete: () {
                    context.read<TaskProvider>().deleteTask(index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
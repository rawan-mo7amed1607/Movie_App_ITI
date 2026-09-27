import 'package:flutter/material.dart';
import 'package:my_counter_app/Controller/task_controller.dart';
import 'package:my_counter_app/Model/task.dart';
import 'package:my_counter_app/Service/shared_pref_helper.dart';

class TaskProvider extends ChangeNotifier {
  final TaskController? taskController;

  TaskProvider({this.taskController});

  List<Task> tasks = [];
  bool isDarkMode = SharedPrefHelper.isDarkMode();

  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    await SharedPrefHelper.setDarkMode(isDarkMode);
    notifyListeners();
  }

  void toggleTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isDone = !tasks[index].isDone;
      notifyListeners();
    }
  }

  void addTask(String title, String desc) {
    tasks.add(Task(title: title, desc: desc));
    notifyListeners();
  }

  void editTask(int index, String title, String desc) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = Task(
        id: tasks[index].id,
        title: title,
        desc: desc,
        isDone: tasks[index].isDone,
      );
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      notifyListeners();
    }
  }

  void getTasks() async {
    if (taskController != null) {
      tasks = await taskController!.getTasks();
      notifyListeners();
    }
  }
}
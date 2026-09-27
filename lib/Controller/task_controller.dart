import '../Model/task.dart';
import '../Service/database_helper.dart';

class TaskController {
  final DatabaseHelper _databaseHelper;

  TaskController({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  Future<List<Task>> getTasks() async {
    return await _databaseHelper.getTasks();
  }

  Future<Task> addTask({required String title, required String desc}) async {
    Task task = Task(title: title, desc: desc);
    int id = await _databaseHelper.addTask(task);
    task.id = id;
    return task;
  }

  Future<void> deleteTask(int id) async {
    await _databaseHelper.deleteTask(id);
  }

  Future<void> editTask({
    required int id,
    required String newTitle,
    required String newDesc,
  }) async {
    Task task = Task(id: id, title: newTitle, desc: newDesc);
    await _databaseHelper.editTask(task);
  }

  Future<void> toggleTask(int id, bool isDone) async {
    await _databaseHelper.toggleTask(id, isDone);
  }
}
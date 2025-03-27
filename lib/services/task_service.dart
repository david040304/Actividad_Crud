import 'dart:convert';
import 'package:cruds/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TaskService {
  static const String _storageKey = 'tasks';

  // Guardar todas las tareas
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskJsonList = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(taskJsonList));
  }

  // Obtener todas las tareas
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_storageKey);
    
    if (tasksJson != null) {
      final List<dynamic> decodedTasks = json.decode(tasksJson);
      return decodedTasks.map((taskJson) => Task.fromJson(taskJson)).toList();
    }
    return [];
  }

  // Añadir una tarea
  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  // Reemplazar una tarea (debido a la inmutabilidad)
  Future<void> replaceTask(Task oldTask, Task newTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((task) => task.id == oldTask.id);
    if (index != -1) {
      tasks[index] = newTask;
      await saveTasks(tasks);
    }
  }

  // Eliminar una tarea
  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }
}
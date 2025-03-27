import 'package:cruds/models/task.dart';
import 'package:cruds/services/task_service.dart';
import 'package:flutter/widgets.dart';

class TaskController with ChangeNotifier {

  List<Task> _tasks = [];
  final TaskService _taskService = TaskService();

  List<Task> get task => _tasks;

  TaskController(){
    loadTask();
  }

  Future<void> loadTask() async{
    _tasks = await _taskService.getTasks();
    notifyListeners();
  }

    Future<void> addTask(Task task) async {
    await _taskService.addTask(task);
    await loadTask();
  }

  Future<void> updateTask(Task oldTask, {
    String? nombre,
    String? detalle,
    TaskStatus? estado
  }) async{
    final updateTask = Task (
      id: oldTask.id,
      nombre: nombre ?? oldTask.nombre,
      detalle: detalle?? oldTask.detalle,
      estado: estado?? oldTask.estado,

    );
    await _taskService.replaceTask(oldTask, updateTask);
    await loadTask();
  }

  Future<void> deleteTask(String taskId) async{
    await _taskService.deleteTask(taskId);
    await loadTask();
  }

  List<Task> getTasksByStatus(TaskStatus status){
    return _tasks.where((task) => task.estado == status).toList();
  }
  
}
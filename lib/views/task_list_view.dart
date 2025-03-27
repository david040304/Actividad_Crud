import 'package:cruds/models/task.dart';
import 'package:cruds/utils/constans.dart';
import 'package:cruds/views/task_datail_view.dart';
import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../utils/task_status.dart';
import 'package:provider/provider.dart';


class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestor de Tareas', style: AppConstants.titleStyle),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Consumer<TaskController>(
        builder: (context, taskController, child) {
          return ListView(
            children: [
              _buildTaskSection(
                context, 
                'Pendientes', 
                taskController.getTasksByStatus(TaskStatus.pendiente),
                Colors.orange
              ),
              _buildTaskSection(
                context, 
                'En Progreso', 
                taskController.getTasksByStatus(TaskStatus.enProgreso),
                Colors.blue
              ),
              _buildTaskSection(
                context, 
                'Completadas', 
                taskController.getTasksByStatus(TaskStatus.completada),
                Colors.green
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailView(),
            ),
          );
        },
        backgroundColor: AppConstants.accentColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskSection(
    BuildContext context, 
    String title, 
    List<Task> tasks, 
    Color color
  ) {
    return ExpansionTile(
      title: Text(
        '$title (${tasks.length})', 
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: tasks.map((task) => _buildTaskTile(context, task, color)).toList(),
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task, Color color) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(task.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(task.detalle),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(Icons.task, color: Colors.white),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: AppConstants.primaryColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailView(task: task),
              ),
            );
          },
        ),
        onLongPress: () {
          _showDeleteDialog(context, task);
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Tarea'),
        content: Text('¿Estás seguro de eliminar esta tarea?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Eliminar'),
            onPressed: () {
              Provider.of<TaskController>(context, listen: false)
                  .deleteTask(task.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
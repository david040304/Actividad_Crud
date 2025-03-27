import 'package:cruds/controllers/task_controller.dart';
import 'package:cruds/models/task.dart';
import 'package:cruds/utils/constans.dart';
import 'package:cruds/utils/task_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailView extends StatefulWidget {
  final Task? task;

  TaskDetailView({this.task});

  @override
  _TaskDetailViewState createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  late TextEditingController _nombreController;
  late TextEditingController _detalleController;
  late TaskStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.task?.nombre ?? '');
    _detalleController = TextEditingController(text: widget.task?.detalle ?? '');
    _selectedStatus = widget.task?.estado ?? TaskStatus.pendiente;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Nueva Tarea' : 'Editar Tarea', 
          style: AppConstants.titleStyle
        ),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Tarea',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _detalleController,
              decoration: InputDecoration(
                labelText: 'Detalles',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<TaskStatus>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: TaskStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.toString().split('.').last),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.accentColor,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                widget.task == null ? 'Crear Tarea' : 'Actualizar Tarea',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    final taskController = Provider.of<TaskController>(context, listen: false);

    if (widget.task == null) {
      // Crear nueva tarea
      final newTask = Task(
        nombre: _nombreController.text,
        detalle: _detalleController.text,
        estado: _selectedStatus,
      );
      taskController.addTask(newTask);
    } else {
      // Actualizar tarea existente
      taskController.updateTask(
        widget.task!,
        nombre: _nombreController.text,
        detalle: _detalleController.text,
        estado: _selectedStatus,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _detalleController.dispose();
    super.dispose();
  }
}
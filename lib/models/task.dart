class Task {
  String? id;
  final String nombre;
  final String detalle;
  final TaskStatus estado;

  Task({
    this.id,
    required this.nombre,
    required this.detalle,
    this.estado = TaskStatus.pendiente ,
  }){
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
  }

    // Convertir de JSON a Objeto
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      nombre: json['nombre'],
      detalle: json['detalle'],
      estado: TaskStatus.values.firstWhere(
        (e) => e.toString() == json['estado'],
        orElse: () => TaskStatus.pendiente,
      ),
    );
  }

    // Convertir de Objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado.toString(),
    };
  }
}

enum  TaskStatus{
  pendiente,
  enProgreso,
  comppletada,
}

  

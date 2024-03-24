class Usuario {
  final int? id;
  final String nombre;
  final String codigoEmpleado;
  final int? status;

  Usuario({
    required this.id,
    required this.nombre,
    required this.codigoEmpleado,
    required this.status,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int?,
      nombre: json['nombre'],
      codigoEmpleado: json['codigo_empleado'],
      status: json['status'] as int?,
    );
  }
}

class GlobalData {
  static Usuario? usuario;
  static int? userId;
}

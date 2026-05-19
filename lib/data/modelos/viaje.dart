/// Representa un viaje largo introducido en el simulador.
class Viaje {
  final String vehiculoMatricula;
  final int kmEstimados;
  final String? descripcion;
  final DateTime fecha;

  const Viaje({
    required this.vehiculoMatricula,
    required this.kmEstimados,
    this.descripcion,
    required this.fecha,
  });
}

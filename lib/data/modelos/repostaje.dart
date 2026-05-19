/// Modelo de datos que representa un repostaje de carburante o recarga eléctrica.
class Repostaje {
  /// Identificador único del repostaje.
  final String? id;

  /// Matrícula del vehículo al que pertenece este repostaje.
  final String vehiculoMatricula;

  /// Fecha en la que se realizó el repostaje.
  final DateTime fecha;

  /// Kilometraje del vehículo en el momento del repostaje.
  final int kilometraje;

  /// Cantidad repostada (Litros para combustión, kWh para eléctricos).
  final double litros;

  /// Precio total pagado por el repostaje.
  final double precioTotal;

  /// Precio por unidad (L o kWh) opcional.
  final double? precioPorLitro;

  const Repostaje({
    this.id,
    required this.vehiculoMatricula,
    required this.fecha,
    required this.kilometraje,
    required this.litros,
    required this.precioTotal,
    this.precioPorLitro,
  });

  Repostaje copyWith({
    String? id,
    String? vehiculoMatricula,
    DateTime? fecha,
    int? kilometraje,
    double? litros,
    double? precioTotal,
    double? precioPorLitro,
  }) {
    return Repostaje(
      id: id ?? this.id,
      vehiculoMatricula: vehiculoMatricula ?? this.vehiculoMatricula,
      fecha: fecha ?? this.fecha,
      kilometraje: kilometraje ?? this.kilometraje,
      litros: litros ?? this.litros,
      precioTotal: precioTotal ?? this.precioTotal,
      precioPorLitro: precioPorLitro ?? this.precioPorLitro,
    );
  }

  Map<String, dynamic> aSupabase() {
    return {
      if (id != null) 'id': id,
      'vehiculo_matricula': vehiculoMatricula,
      'fecha': fecha.toIso8601String().split('T').first,
      'kilometraje': kilometraje,
      'litros': litros,
      'precio_total': precioTotal,
      if (precioPorLitro != null) 'precio_por_litro': precioPorLitro,
    };
  }

  factory Repostaje.desdeSupabase(Map<String, dynamic> mapa) {
    return Repostaje(
      id: mapa['id'] as String?,
      vehiculoMatricula: mapa['vehiculo_matricula'] as String,
      fecha: DateTime.parse(mapa['fecha'] as String),
      kilometraje: mapa['kilometraje'] as int,
      litros: (mapa['litros'] as num).toDouble(),
      precioTotal: (mapa['precio_total'] as num).toDouble(),
      precioPorLitro: mapa['precio_por_litro'] != null
          ? (mapa['precio_por_litro'] as num).toDouble()
          : null,
    );
  }

  @override
  String toString() =>
      'Repostaje(id: $id, fecha: $fecha, km: $kilometraje, L/kWh: $litros, total: $precioTotal)';
}

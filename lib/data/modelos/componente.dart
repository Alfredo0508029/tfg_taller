/// Modelo principal que define un 'Componente' o 'Pieza de recambio' de un vehículo.
/// Cada componente está estrictamente vinculado a un único vehículo a través de su
/// matrícula y realiza un seguimiento automático de sus intervalos de cambio.
class Componente {
  /// Identificador universal único (UUID). Generado automáticamente por la base 
  /// de datos (Supabase) al insertar el componente. Si es `null`, indica que
  /// el componente es local y aún no ha sido sincronizado en el servidor.
  final String? id;

  /// Clave Foránea (Foreign Key) que relaciona esta pieza con un vehículo específico.
  /// Contiene la matrícula exacta de dicho vehículo matriz.
  final String vehiculoMatricula;

  /// Nombre comercial o coloquial de la pieza de recambio.
  /// Por ejemplo: 'Filtro de Aceite', 'Correa de Distribución', 'Bujías'.
  final String nombre;

  /// Vida útil teórica recomendada por el fabricante para esta pieza,
  /// expresada en kilómetros de recorrido total.
  final int intervaloKm;

  /// Registro numérico del odómetro (kilometraje del coche) en el momento exacto
  /// en que se sustituyó o revisó esta pieza por última vez.
  final int ultimoCambioKm;

  /// Constructor del modelo Componente.
  const Componente({
    this.id,
    required this.vehiculoMatricula,
    required this.nombre,
    required this.intervaloKm,
    required this.ultimoCambioKm,
  });

  /// Calcula algebraicamente el punto absoluto en el cuentakilómetros del coche
  /// donde se deberá realizar el siguiente cambio o inspección técnica.
  int get proximoCambioKm => ultimoCambioKm + intervaloKm;

  /// Calcula matemáticamente el diferencial de kilómetros que le quedan de vida 
  /// útil a la pieza antes de fallar. Si el número devuelto es negativo, significa
  /// que hemos superado el intervalo y el mantenimiento es urgente (números rojos).
  int kmRestantes(int kilometrajeActual) => proximoCambioKm - kilometrajeActual;

  /// Motor de cálculo visual para las barras de progreso o "semáforos" de la app.
  /// Devuelve una fracción decimal (ratio) del uso porcentual del componente.
  /// Un valor de 0.0 es "Pieza nueva (recién cambiada)", mientras que 1.0 (o superior)
  /// significa "Pieza totalmente gastada (requiere sustitución)".
  double porcentajeUso(int kilometrajeActual) {
    if (intervaloKm == 0) return 0; // Previene divisiones por cero (Infinity).
    return (kilometrajeActual - ultimoCambioKm) / intervaloKm;
  }

  /// Crea una copia del componente con los campos indicados modificados.
  Componente copyWith({
    String? id,
    String? vehiculoMatricula,
    String? nombre,
    int? intervaloKm,
    int? ultimoCambioKm,
  }) {
    return Componente(
      id: id ?? this.id,
      vehiculoMatricula: vehiculoMatricula ?? this.vehiculoMatricula,
      nombre: nombre ?? this.nombre,
      intervaloKm: intervaloKm ?? this.intervaloKm,
      ultimoCambioKm: ultimoCambioKm ?? this.ultimoCambioKm,
    );
  }

  /// Convierte el modelo a un mapa para enviarlo a Supabase.
  Map<String, dynamic> aSupabase() {
    return {
      if (id != null) 'id': id,
      'vehiculo_matricula': vehiculoMatricula,
      'nombre': nombre,
      'intervalo_km': intervaloKm,
      'ultimo_cambio_km': ultimoCambioKm,
    };
  }

  /// Crea un Componente a partir de un mapa recibido de Supabase.
  factory Componente.desdeSupabase(Map<String, dynamic> mapa) {
    return Componente(
      id: mapa['id'] as String?,
      vehiculoMatricula: mapa['vehiculo_matricula'] as String,
      nombre: mapa['nombre'] as String,
      intervaloKm: mapa['intervalo_km'] as int,
      ultimoCambioKm: mapa['ultimo_cambio_km'] as int,
    );
  }

  @override
  String toString() =>
      'Componente(id: $id, nombre: $nombre, intervalo: $intervaloKm km)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Componente && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

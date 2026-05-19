/// Clase transaccional que documenta permanentemente un evento en el tiempo.
/// Almacena todos los detalles contextuales del momento exacto en el que a
/// un coche se le realizó un mantenimiento o sustitución de una pieza.
class RegistroMantenimiento {
  /// Identificador criptográfico único de este registro generado por la base de datos.
  final String? id;

  /// Referencia directa (FK) al UUID de la pieza/componente físico que fue manipulado.
  final String componenteId;

  /// Matrícula matricula identificativa del vehículo involucrado en esta operación.
  final String vehiculoMatricula;

  /// Aunque ya tenemos el componenteId, almacenamos como texto estático el nombre 
  /// del componente ("foto fija"). Esto asegura que si el usuario borra o renombra
  /// el componente en el futuro, el histórico permanezca inalterado e inteligible.
  final String nombreComponente;

  /// Fecha oficial (Día/Mes/Año) en la que se llevó el coche al taller o se operó.
  final DateTime fecha;

  /// Lectura exacta del odómetro general del coche durante aquel día.
  final int kilometraje;

  /// Anotaciones mecánicas, recordatorios u observaciones opcionales que 
  /// el mecánico o el dueño anotan (ej: "Se aflojó tuerca izquierda también").
  final String? notas;

  /// URL pública de la fotografía del mantenimiento, almacenada en Supabase Storage.
  /// Campo opcional: puede ser `null` si no se adjuntó ninguna imagen al registro.
  final String? imagenUrl;

  /// Precio o coste total invertido en esta operación de mantenimiento.
  /// Campo opcional: puede ser nulo o 0 si se hizo en casa o sin coste.
  final double? precio;

  /// Constructor del modelo RegistroMantenimiento.
  const RegistroMantenimiento({
    this.id,
    required this.componenteId,
    required this.vehiculoMatricula,
    required this.nombreComponente,
    required this.fecha,
    required this.kilometraje,
    this.notas,
    this.imagenUrl,
    this.precio,
  });

  /// Crea una copia del registro con los campos indicados modificados.
  RegistroMantenimiento copyWith({
    String? id,
    String? componenteId,
    String? vehiculoMatricula,
    String? nombreComponente,
    DateTime? fecha,
    int? kilometraje,
    String? notas,
    String? imagenUrl,
    double? precio,
  }) {
    return RegistroMantenimiento(
      id: id ?? this.id,
      componenteId: componenteId ?? this.componenteId,
      vehiculoMatricula: vehiculoMatricula ?? this.vehiculoMatricula,
      nombreComponente: nombreComponente ?? this.nombreComponente,
      fecha: fecha ?? this.fecha,
      kilometraje: kilometraje ?? this.kilometraje,
      notas: notas ?? this.notas,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      precio: precio ?? this.precio,
    );
  }

  /// Convierte el modelo a un mapa para enviarlo a Supabase.
  /// La fecha se almacena como cadena de solo fecha (yyyy-MM-dd).
  Map<String, dynamic> aSupabase() {
    return {
      if (id != null) 'id': id,
      'componente_id': componenteId,
      'vehiculo_matricula': vehiculoMatricula,
      'nombre_componente': nombreComponente,
      'fecha': fecha.toIso8601String().split('T').first,
      'kilometraje': kilometraje,
      'notas': notas,
      // Incluimos la URL de la imagen del mantenimiento solo si existe
      if (imagenUrl != null) 'imagen_url': imagenUrl,
      if (precio != null) 'precio': precio,
    };
  }

  /// Crea un RegistroMantenimiento a partir de un mapa recibido de Supabase.
  factory RegistroMantenimiento.desdeSupabase(Map<String, dynamic> mapa) {
    return RegistroMantenimiento(
      id: mapa['id'] as String?,
      componenteId: mapa['componente_id'] as String,
      vehiculoMatricula: mapa['vehiculo_matricula'] as String,
      nombreComponente: mapa['nombre_componente'] as String,
      fecha: DateTime.parse(mapa['fecha'] as String),
      kilometraje: mapa['kilometraje'] as int,
      notas: mapa['notas'] as String?,
      // Leemos la URL de la imagen si Supabase la devuelve
      imagenUrl: mapa['imagen_url'] as String?,
      precio: mapa['precio'] != null ? (mapa['precio'] as num).toDouble() : null,
    );
  }

  @override
  String toString() =>
      'RegistroMantenimiento(id: $id, componente: $nombreComponente, fecha: $fecha, km: $kilometraje)';
}

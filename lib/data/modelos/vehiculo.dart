/// Modelo de datos fundamental que representa un vehículo registrado en la aplicación.
/// Esta clase es el pilar central sobre el que se estructuran los componentes 
/// y el historial de mantenimiento en la base de datos de Supabase.
class Vehiculo {
  /// Matrícula única del vehículo. En la base de datos de Supabase actúa como 
  /// Clave Primaria (Primary Key), permitiendo identificar un coche inequívocamente.
  final String? matricula;

  /// Marca comercial del vehículo (ejemplo: 'Toyota', 'Ford', 'BMW').
  /// Es un campo obligatorio para el reconocimiento visual por parte del usuario.
  final String marca;

  /// Modelo específico del vehículo (ejemplo: 'Corolla', 'Focus', 'Serie 3').
  /// Junto con la marca, forma el título principal que se mostrará en pantalla.
  final String modelo;

  /// Año exacto de fabricación o matriculación del vehículo.
  /// Resulta muy útil para distinguir versiones de un mismo modelo si el usuario
  /// registra dos coches iguales pero de distintas generaciones.
  final int anio;

  /// Kilometraje total actual del vehículo. Este es, sin duda, el valor más 
  /// crítico del modelo, ya que todos los cálculos de desgaste de piezas y 
  /// notificaciones "Rojo/Amarillo/Verde" del Dashboard dependen de este número.
  final int kilometrajeActual;

  /// URL pública de la imagen del vehículo almacenada en Supabase Storage.
  /// Es un campo opcional: puede ser `null` si el usuario no ha añadido ninguna foto.
  final String? imagenUrl;

  /// Tipo de carburante que utiliza el vehículo (gasolina, diésel, eléctrico, híbrido...).
  /// Útil para calcular el uso de combustible, precio por km, o usar un sufijo de medida (Litros o kWh).
  final String tipoCarburante;

  /// Constructor constante (`const`) de la clase Vehiculo.
  /// Exige que todos los campos sean proporcionados obligatoriamente (`required`),
  /// excepto la matrícula e imagenUrl que pueden ser nulas.
  const Vehiculo({
    this.matricula,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.kilometrajeActual,
    this.imagenUrl,
    required this.tipoCarburante,
  });

  /// Patrón de diseño 'Copy-With'. Crea un clon exacto (una nueva instancia) de este 
  /// vehículo modificando únicamente los parámetros que se le pasen como argumento.
  /// Es imprescindible para mantener el principio de Inmutabilidad requerido por Riverpod.
  Vehiculo copyWith({
    String? matricula,
    String? marca,
    String? modelo,
    int? anio,
    int? kilometrajeActual,
    String? imagenUrl,
    bool limpiarImagen = false,
    String? tipoCarburante,
  }) {
    return Vehiculo(
      matricula: matricula ?? this.matricula,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      kilometrajeActual: kilometrajeActual ?? this.kilometrajeActual,
      // Si se pide limpiar la imagen, se pone a null; si no, se usa la nueva o la existente
      imagenUrl: limpiarImagen ? null : imagenUrl ?? this.imagenUrl,
      tipoCarburante: tipoCarburante ?? this.tipoCarburante,
    );
  }

  /// Serializa (convierte) el objeto Vehiculo de Dart en un Mapa genérico (JSON).
  /// Este paso es obligatorio antes de poder mandar el vehículo a la API de Supabase,
  /// ya que las bases de datos externas no entienden objetos Dart, solo JSON ('Map').
  Map<String, dynamic> aSupabase() {
    return {
      if (matricula != null) 'matricula': matricula,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'kilometraje_actual': kilometrajeActual,
      // Incluimos la URL de la imagen solo si tiene valor
      if (imagenUrl != null) 'imagen_url': imagenUrl,
      'tipo_carburante': tipoCarburante,
    };
  }

  /// Método de fábrica (Factory constructor) que realiza el proceso inverso (Deserialización).
  /// Recibe un Mapa JSON proveniente de Supabase (tras una petición SELECT)
  /// y lo mapea automáticamente mapeando cada clave a las propiedades del objeto Dart.
  factory Vehiculo.desdeSupabase(Map<String, dynamic> mapa) {
    return Vehiculo(
      matricula: mapa['matricula'] as String?,
      marca: mapa['marca'] as String,
      modelo: mapa['modelo'] as String,
      anio: mapa['anio'] as int,
      kilometrajeActual: mapa['kilometraje_actual'] as int,
      // Leemos la URL de imagen si existe en la base de datos
      imagenUrl: mapa['imagen_url'] as String?,
      // Por compatibilidad con coches guardados sin este campo, 
      // si viene null lo rellenamos como 'Desconocido' o 'Gasolina' por defecto.
      tipoCarburante: mapa['tipo_carburante'] as String? ?? 'gasolina',
    );
  }

  /// Nombre completo del vehículo (marca + modelo + año).
  String get nombreCompleto => '$marca $modelo ($anio)';

  @override
  String toString() =>
      'Vehiculo(matricula: $matricula, marca: $marca, modelo: $modelo, anio: $anio, km: $kilometrajeActual)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehiculo && other.matricula == matricula;

  @override
  int get hashCode => matricula.hashCode;
}

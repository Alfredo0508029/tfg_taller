import '../../data/modelos/vehiculo.dart';

/// Interfaz abstracta del repositorio de vehículos.
/// Define el contrato de operaciones disponibles sobre vehículos
/// independientemente de la fuente de datos (Supabase, memoria, etc.).
abstract class IVehiculoRepositorio {
  /// Obtiene la lista completa de vehículos almacenados.
  Future<List<Vehiculo>> obtenerTodos();

  /// Obtiene un vehículo por su matrícula. Devuelve null si no existe.
  Future<Vehiculo?> obtenerPorMatricula(String matricula);

  /// Guarda un vehículo nuevo.
  Future<void> guardar(Vehiculo vehiculo);

  /// Actualiza un vehículo existente.
  Future<void> actualizar(Vehiculo vehiculo);

  /// Actualiza solo el kilometraje de un vehículo.
  Future<void> actualizarKilometraje(String matricula, int nuevoKm);

  /// Elimina un vehículo y todos sus datos asociados.
  Future<void> eliminar(String matricula);
}

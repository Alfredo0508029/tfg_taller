import '../../data/modelos/componente.dart';

/// Interfaz abstracta del repositorio de componentes.
abstract class IComponenteRepositorio {
  /// Obtiene todos los componentes de un vehículo específico.
  Future<List<Componente>> obtenerPorVehiculo(String matricula);

  /// Obtiene un componente por su ID (UUID).
  Future<Componente?> obtenerPorId(String id);

  /// Guarda un nuevo componente.
  Future<void> guardar(Componente componente);

  /// Actualiza un componente existente.
  Future<void> actualizar(Componente componente);

  /// Actualiza el kilometraje del último cambio.
  Future<void> actualizarUltimoCambio(String id, int nuevoKm);

  /// Elimina un componente y sus registros asociados.
  Future<void> eliminar(String id);
}

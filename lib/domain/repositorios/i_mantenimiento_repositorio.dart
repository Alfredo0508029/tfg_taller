import '../../data/modelos/registro_mantenimiento.dart';

/// Interfaz abstracta del repositorio de registros de mantenimiento.
abstract class IMantenimientoRepositorio {
  /// Obtiene el historial de mantenimiento de un vehículo.
  Future<List<RegistroMantenimiento>> obtenerPorVehiculo(String matricula);

  /// Obtiene los registros de un componente específico.
  Future<List<RegistroMantenimiento>> obtenerPorComponente(String componenteId);

  /// Guarda un nuevo registro de mantenimiento.
  Future<void> guardar(RegistroMantenimiento registro);

  /// Elimina un registro de mantenimiento.
  Future<void> eliminar(String id);

  /// Cuenta el total de mantenimientos de un vehículo.
  Future<int> contarPorVehiculo(String matricula);

  /// Devuelve los componentes más frecuentemente mantenidos.
  Future<List<Map<String, dynamic>>> componentesMasFrecuentes(String matricula);
}

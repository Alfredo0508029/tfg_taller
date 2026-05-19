import '../../data/modelos/repostaje.dart';

/// Interfaz para el repositorio de repostajes.
abstract class IRepostajeRepositorio {
  Future<List<Repostaje>> obtenerPorVehiculo(String matricula);
  Future<void> guardar(Repostaje repostaje);
  Future<void> actualizar(Repostaje repostaje);
  Future<void> eliminar(String id);
}

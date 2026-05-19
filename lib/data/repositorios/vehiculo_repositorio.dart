import '../../domain/repositorios/i_vehiculo_repositorio.dart';
import '../dao/vehiculo_supabase_dao.dart';
import '../modelos/vehiculo.dart';

/// Implementación concreta del repositorio de vehículos usando Supabase.
class VehiculoRepositorio implements IVehiculoRepositorio {
  final VehiculoSupabaseDao _dao = VehiculoSupabaseDao();

  @override
  Future<List<Vehiculo>> obtenerTodos() => _dao.obtenerTodos();

  @override
  Future<Vehiculo?> obtenerPorMatricula(String matricula) =>
      _dao.obtenerPorMatricula(matricula);

  @override
  Future<void> guardar(Vehiculo vehiculo) => _dao.insertar(vehiculo);

  @override
  Future<void> actualizar(Vehiculo vehiculo) => _dao.actualizar(vehiculo);

  @override
  Future<void> actualizarKilometraje(String matricula, int nuevoKm) =>
      _dao.actualizarKilometraje(matricula, nuevoKm);

  @override
  Future<void> eliminar(String matricula) => _dao.eliminar(matricula);
}

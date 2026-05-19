import '../../domain/repositorios/i_mantenimiento_repositorio.dart';
import '../dao/mantenimiento_supabase_dao.dart';
import '../modelos/registro_mantenimiento.dart';

/// Implementación concreta del repositorio de mantenimiento usando Supabase.
class MantenimientoRepositorio implements IMantenimientoRepositorio {
  final MantenimientoSupabaseDao _dao = MantenimientoSupabaseDao();

  @override
  Future<List<RegistroMantenimiento>> obtenerPorVehiculo(String matricula) =>
      _dao.obtenerPorVehiculo(matricula);

  @override
  Future<List<RegistroMantenimiento>> obtenerPorComponente(String componenteId) =>
      _dao.obtenerPorComponente(componenteId);

  @override
  Future<void> guardar(RegistroMantenimiento registro) =>
      _dao.insertar(registro);

  @override
  Future<void> eliminar(String id) => _dao.eliminar(id);

  @override
  Future<int> contarPorVehiculo(String matricula) =>
      _dao.contarPorVehiculo(matricula);

  @override
  Future<List<Map<String, dynamic>>> componentesMasFrecuentes(String matricula) =>
      _dao.componentesMasFrecuentes(matricula);
}

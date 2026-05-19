import '../../domain/repositorios/i_componente_repositorio.dart';
import '../dao/componente_supabase_dao.dart';
import '../modelos/componente.dart';

/// Implementación concreta del repositorio de componentes usando Supabase.
class ComponenteRepositorio implements IComponenteRepositorio {
  final ComponenteSupabaseDao _dao = ComponenteSupabaseDao();

  @override
  Future<List<Componente>> obtenerPorVehiculo(String matricula) =>
      _dao.obtenerPorVehiculo(matricula);

  @override
  Future<Componente?> obtenerPorId(String id) => _dao.obtenerPorId(id);

  @override
  Future<void> guardar(Componente componente) => _dao.insertar(componente);

  @override
  Future<void> actualizar(Componente componente) => _dao.actualizar(componente);

  @override
  Future<void> actualizarUltimoCambio(String id, int nuevoKm) =>
      _dao.actualizarUltimoCambio(id, nuevoKm);

  @override
  Future<void> eliminar(String id) => _dao.eliminar(id);
}

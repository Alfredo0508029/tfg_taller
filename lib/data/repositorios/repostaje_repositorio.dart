import '../../domain/repositorios/i_repostaje_repositorio.dart';
import '../dao/repostaje_supabase_dao.dart';
import '../modelos/repostaje.dart';

/// Implementación del repositorio de repostajes conectada al DAO de Supabase.
class RepostajeRepositorio implements IRepostajeRepositorio {
  final RepostajeSupabaseDao _dao = RepostajeSupabaseDao();

  @override
  Future<List<Repostaje>> obtenerPorVehiculo(String matricula) =>
      _dao.obtenerPorVehiculo(matricula);

  @override
  Future<void> guardar(Repostaje repostaje) => _dao.insertar(repostaje);

  @override
  Future<void> actualizar(Repostaje repostaje) => _dao.actualizar(repostaje);

  @override
  Future<void> eliminar(String id) => _dao.eliminar(id);
}

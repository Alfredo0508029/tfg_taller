import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/repostaje.dart';

/// DAO para interactuar con la tabla de repostajes en Supabase.
class RepostajeSupabaseDao {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> insertar(Repostaje repostaje) async {
    final mapa = repostaje.aSupabase();
    mapa['usuario_id'] = _client.auth.currentUser?.id;
    await _client.from('repostajes').insert(mapa);
  }

  Future<List<Repostaje>> obtenerPorVehiculo(String matricula) async {
    final datos = await _client
        .from('repostajes')
        .select()
        .eq('vehiculo_matricula', matricula)
        .order('fecha', ascending: false)
        .order('kilometraje', ascending: false);
    return datos.map((m) => Repostaje.desdeSupabase(m)).toList();
  }

  Future<void> actualizar(Repostaje repostaje) async {
    await _client
        .from('repostajes')
        .update(repostaje.aSupabase())
        .eq('id', repostaje.id!);
  }

  Future<void> eliminar(String id) async {
    await _client.from('repostajes').delete().eq('id', id);
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/componente.dart';

/// DAO (Data Access Object) para la tabla de componentes en Supabase.
/// Gestiona el acceso a datos de los componentes de cada vehículo.
class ComponenteSupabaseDao {
  /// Referencia al cliente de Supabase.
  SupabaseClient get _client => Supabase.instance.client;

  /// Inserta un nuevo componente en Supabase.
  Future<void> insertar(Componente componente) async {
    final mapa = componente.aSupabase();
    mapa['usuario_id'] = _client.auth.currentUser?.id;
    await _client.from('componentes').insert(mapa);
  }

  /// Obtiene todos los componentes de un vehículo específico.
  Future<List<Componente>> obtenerPorVehiculo(String matricula) async {
    final datos = await _client
        .from('componentes')
        .select()
        .eq('vehiculo_matricula', matricula)
        .order('nombre');
    return datos.map((m) => Componente.desdeSupabase(m)).toList();
  }

  /// Obtiene un componente por su ID (UUID).
  Future<Componente?> obtenerPorId(String id) async {
    final datos = await _client
        .from('componentes')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (datos == null) return null;
    return Componente.desdeSupabase(datos);
  }

  /// Actualiza los datos de un componente existente.
  Future<void> actualizar(Componente componente) async {
    await _client
        .from('componentes')
        .update(componente.aSupabase())
        .eq('id', componente.id!);
  }

  /// Actualiza el kilometraje del último cambio de un componente.
  Future<void> actualizarUltimoCambio(String id, int nuevoKm) async {
    await _client
        .from('componentes')
        .update({'ultimo_cambio_km': nuevoKm})
        .eq('id', id);
  }

  /// Elimina un componente (CASCADE en Supabase elimina sus registros).
  Future<void> eliminar(String id) async {
    await _client.from('componentes').delete().eq('id', id);
  }

  /// Cuenta el número de componentes de un vehículo.
  Future<int> contarPorVehiculo(String matricula) async {
    final resultado = await _client
        .from('componentes')
        .select()
        .eq('vehiculo_matricula', matricula)
        .count(CountOption.exact);
    return resultado.count;
  }
}

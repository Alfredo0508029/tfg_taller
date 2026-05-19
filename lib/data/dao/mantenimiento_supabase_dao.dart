import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/registro_mantenimiento.dart';

/// DAO para la tabla de registros de mantenimiento en Supabase.
/// Gestiona el historial completo de mantenimientos de todos los vehículos.
class MantenimientoSupabaseDao {
  /// Referencia al cliente de Supabase.
  SupabaseClient get _client => Supabase.instance.client;

  /// Inserta un nuevo registro de mantenimiento.
  Future<void> insertar(RegistroMantenimiento registro) async {
    final mapa = registro.aSupabase();
    mapa['usuario_id'] = _client.auth.currentUser?.id;
    await _client
        .from('registros_mantenimiento')
        .insert(mapa);
  }

  /// Obtiene todo el historial de mantenimiento de un vehículo,
  /// ordenado por fecha descendente (más reciente primero).
  Future<List<RegistroMantenimiento>> obtenerPorVehiculo(
    String matricula,
  ) async {
    final datos = await _client
        .from('registros_mantenimiento')
        .select()
        .eq('vehiculo_matricula', matricula)
        .order('fecha', ascending: false);
    return datos.map((m) => RegistroMantenimiento.desdeSupabase(m)).toList();
  }

  /// Obtiene los registros de mantenimiento de un componente específico.
  Future<List<RegistroMantenimiento>> obtenerPorComponente(
    String componenteId,
  ) async {
    final datos = await _client
        .from('registros_mantenimiento')
        .select()
        .eq('componente_id', componenteId)
        .order('fecha', ascending: false);
    return datos.map((m) => RegistroMantenimiento.desdeSupabase(m)).toList();
  }

  /// Obtiene todos los registros de todos los vehículos para estadísticas globales.
  Future<List<RegistroMantenimiento>> obtenerTodos() async {
    final datos = await _client
        .from('registros_mantenimiento')
        .select()
        .order('fecha', ascending: false);
    return datos.map((m) => RegistroMantenimiento.desdeSupabase(m)).toList();
  }

  /// Cuenta el total de mantenimientos de un vehículo.
  Future<int> contarPorVehiculo(String matricula) async {
    final resultado = await _client
        .from('registros_mantenimiento')
        .select()
        .eq('vehiculo_matricula', matricula)
        .count(CountOption.exact);
    return resultado.count;
  }

  /// Obtiene los componentes ordenados por frecuencia de mantenimiento.
  /// Realiza una agrupación manual ya que Supabase REST no soporta GROUP BY directo.
  Future<List<Map<String, dynamic>>> componentesMasFrecuentes(
    String matricula,
  ) async {
    final datos = await _client
        .from('registros_mantenimiento')
        .select('nombre_componente')
        .eq('vehiculo_matricula', matricula);

    // Agrupar manualmente por nombre_componente
    final conteo = <String, int>{};
    for (final fila in datos) {
      final nombre = fila['nombre_componente'] as String;
      conteo[nombre] = (conteo[nombre] ?? 0) + 1;
    }

    // Ordenar por frecuencia descendente y limitar a 10
    final ordenado = conteo.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ordenado
        .take(10)
        .map((e) => {'nombre_componente': e.key, 'total': e.value})
        .toList();
  }

  /// Elimina un registro de mantenimiento por su ID (UUID).
  Future<void> eliminar(String id) async {
    await _client
        .from('registros_mantenimiento')
        .delete()
        .eq('id', id);
  }
}

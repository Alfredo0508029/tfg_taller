import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/modelos/registro_mantenimiento.dart';
import '../data/repositorios/mantenimiento_repositorio.dart';

/// Estado del proveedor de registros de mantenimiento.
class EstadoMantenimiento {
  final List<RegistroMantenimiento> registros;
  final bool cargando;
  final String? error;

  const EstadoMantenimiento({
    this.registros = const [],
    this.cargando = false,
    this.error,
  });

  EstadoMantenimiento copyWith({
    List<RegistroMantenimiento>? registros,
    bool? cargando,
    String? error,
    bool limpiarError = false,
  }) {
    return EstadoMantenimiento(
      registros: registros ?? this.registros,
      cargando: cargando ?? this.cargando,
      error: limpiarError ? null : error ?? this.error,
    );
  }
}

/// Notifier que gestiona el historial de mantenimiento.
class MantenimientoNotifier extends StateNotifier<EstadoMantenimiento> {
  final MantenimientoRepositorio _repositorio;

  MantenimientoNotifier(this._repositorio) : super(const EstadoMantenimiento());

  /// Carga el historial de mantenimiento de un vehículo.
  Future<void> cargarHistorial(String matricula) async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final lista = await _repositorio.obtenerPorVehiculo(matricula);
      state = state.copyWith(registros: lista, cargando: false);
    } catch (e) {
      state = state.copyWith(
        cargando: false,
        error: 'Error al cargar historial: $e',
      );
    }
  }

  /// Registra un nuevo mantenimiento y recarga el historial.
  Future<bool> registrarMantenimiento(RegistroMantenimiento registro) async {
    try {
      await _repositorio.guardar(registro);
      await cargarHistorial(registro.vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al registrar mantenimiento: $e');
      return false;
    }
  }

  /// Elimina un registro de mantenimiento.
  Future<bool> eliminarRegistro(String id, String vehiculoMatricula) async {
    try {
      await _repositorio.eliminar(id);
      await cargarHistorial(vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar registro: $e');
      return false;
    }
  }

  /// Obtiene estadísticas: total de mantenimientos y componentes frecuentes.
  Future<Map<String, dynamic>> obtenerEstadisticas(String matricula) async {
    final total = await _repositorio.contarPorVehiculo(matricula);
    final frecuentes = await _repositorio.componentesMasFrecuentes(matricula);
    return {'total': total, 'frecuentes': frecuentes};
  }

  /// Obtiene todos los mantenimientos para calcular dinero invertido sin modificar estado
  Future<List<RegistroMantenimiento>> obtenerTodosMantenimientosParaStats(String matricula) async {
    return await _repositorio.obtenerPorVehiculo(matricula);
  }
}

/// Provider global del historial de mantenimiento.
final mantenimientoProvider =
    StateNotifierProvider<MantenimientoNotifier, EstadoMantenimiento>((ref) {
      return MantenimientoNotifier(MantenimientoRepositorio());
    });

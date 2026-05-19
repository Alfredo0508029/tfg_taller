import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/modelos/componente.dart';
import '../data/repositorios/componente_repositorio.dart';

/// Estado del proveedor de componentes.
class EstadoComponentes {
  final List<Componente> componentes;
  final bool cargando;
  final String? error;

  const EstadoComponentes({
    this.componentes = const [],
    this.cargando = false,
    this.error,
  });

  EstadoComponentes copyWith({
    List<Componente>? componentes,
    bool? cargando,
    String? error,
    bool limpiarError = false,
  }) {
    return EstadoComponentes(
      componentes: componentes ?? this.componentes,
      cargando: cargando ?? this.cargando,
      error: limpiarError ? null : error ?? this.error,
    );
  }
}

/// Notifier que gestiona el estado de los componentes de un vehículo.
class ComponenteNotifier extends StateNotifier<EstadoComponentes> {
  final ComponenteRepositorio _repositorio;

  ComponenteNotifier(this._repositorio) : super(const EstadoComponentes());

  /// Carga los componentes de un vehículo específico.
  Future<void> cargarComponentes(String matricula) async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final lista = await _repositorio.obtenerPorVehiculo(matricula);
      state = state.copyWith(componentes: lista, cargando: false);
    } catch (e) {
      state = state.copyWith(
        cargando: false,
        error: 'Error al cargar componentes: $e',
      );
    }
  }

  /// Agrega un nuevo componente y recarga la lista.
  Future<bool> agregarComponente(Componente componente) async {
    try {
      await _repositorio.guardar(componente);
      await cargarComponentes(componente.vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al guardar componente: $e');
      return false;
    }
  }

  /// Actualiza un componente existente.
  Future<bool> actualizarComponente(Componente componente) async {
    try {
      await _repositorio.actualizar(componente);
      await cargarComponentes(componente.vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al actualizar componente: $e');
      return false;
    }
  }

  /// Actualiza el km del último cambio de un componente (al registrar mantenimiento).
  Future<bool> registrarCambio(
    String componenteId,
    int nuevoKm,
    String vehiculoMatricula,
  ) async {
    try {
      await _repositorio.actualizarUltimoCambio(componenteId, nuevoKm);
      await cargarComponentes(vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al registrar cambio: $e');
      return false;
    }
  }

  /// Elimina un componente.
  Future<bool> eliminarComponente(String componenteId, String vehiculoMatricula) async {
    try {
      await _repositorio.eliminar(componenteId);
      await cargarComponentes(vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar componente: $e');
      return false;
    }
  }
}

/// Provider global del estado de componentes.
final componenteProvider =
    StateNotifierProvider<ComponenteNotifier, EstadoComponentes>((ref) {
      return ComponenteNotifier(ComponenteRepositorio());
    });

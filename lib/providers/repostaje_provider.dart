import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/modelos/repostaje.dart';
import '../data/repositorios/repostaje_repositorio.dart';

class EstadoRepostajes {
  final List<Repostaje> repostajes;
  final bool cargando;
  final String? error;

  const EstadoRepostajes({
    this.repostajes = const [],
    this.cargando = false,
    this.error,
  });

  EstadoRepostajes copyWith({
    List<Repostaje>? repostajes,
    bool? cargando,
    String? error,
  }) {
    return EstadoRepostajes(
      repostajes: repostajes ?? this.repostajes,
      cargando: cargando ?? this.cargando,
      error: error ?? this.error,
    );
  }
}

class RepostajeNotifier extends StateNotifier<EstadoRepostajes> {
  final RepostajeRepositorio _repositorio;

  RepostajeNotifier(this._repositorio) : super(const EstadoRepostajes());

  Future<void> cargarRepostajes(String matricula) async {
    state = state.copyWith(cargando: true, error: null);
    try {
      final lista = await _repositorio.obtenerPorVehiculo(matricula);
      state = state.copyWith(repostajes: lista, cargando: false);
    } catch (e) {
      state = state.copyWith(
        cargando: false,
        error: 'Error al cargar repostajes: $e',
      );
    }
  }

  Future<bool> registrarRepostaje(Repostaje repostaje) async {
    try {
      await _repositorio.guardar(repostaje);
      await cargarRepostajes(repostaje.vehiculoMatricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al guardar repostaje: $e');
      return false;
    }
  }

  Future<bool> eliminarRepostaje(String id, String matricula) async {
    try {
      await _repositorio.eliminar(id);
      await cargarRepostajes(matricula);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar repostaje: $e');
      return false;
    }
  }
}

final repostajeProvider =
    StateNotifierProvider<RepostajeNotifier, EstadoRepostajes>((ref) {
  return RepostajeNotifier(RepostajeRepositorio());
});

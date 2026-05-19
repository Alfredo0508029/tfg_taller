import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/modelos/vehiculo.dart';
import '../data/repositorios/vehiculo_repositorio.dart';
import '../servicios/notificaciones_servicio.dart';

/// Estado del proveedor de vehículos.
class EstadoVehiculos {
  /// Lista de vehículos cargados.
  final List<Vehiculo> vehiculos;

  /// Vehículo actualmente seleccionado (para el dashboard).
  final Vehiculo? vehiculoSeleccionado;

  /// Indica si se está cargando información.
  final bool cargando;

  /// Mensaje de error, si lo hay.
  final String? error;

  const EstadoVehiculos({
    this.vehiculos = const [],
    this.vehiculoSeleccionado,
    this.cargando = false,
    this.error,
  });

  EstadoVehiculos copyWith({
    List<Vehiculo>? vehiculos,
    Vehiculo? vehiculoSeleccionado,
    bool? cargando,
    String? error,
    bool limpiarVehiculo = false,
    bool limpiarError = false,
  }) {
    return EstadoVehiculos(
      vehiculos: vehiculos ?? this.vehiculos,
      vehiculoSeleccionado: limpiarVehiculo
          ? null
          : vehiculoSeleccionado ?? this.vehiculoSeleccionado,
      cargando: cargando ?? this.cargando,
      error: limpiarError ? null : error ?? this.error,
    );
  }
}

/// Notifier que gestiona el estado de los vehículos.
class VehiculoNotifier extends StateNotifier<EstadoVehiculos> {
  final VehiculoRepositorio _repositorio;

  VehiculoNotifier(this._repositorio) : super(const EstadoVehiculos()) {
    cargarVehiculos();
  }

  /// Carga todos los vehículos desde la base de datos.
  Future<void> cargarVehiculos() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final lista = await _repositorio.obtenerTodos();
      state = state.copyWith(vehiculos: lista, cargando: false);
    } catch (e) {
      state = state.copyWith(
        cargando: false,
        error: 'Error al cargar vehículos: $e',
      );
    }
  }

  /// Selecciona el vehículo activo para el dashboard.
  void seleccionarVehiculo(Vehiculo vehiculo) {
    state = state.copyWith(vehiculoSeleccionado: vehiculo);
  }

  /// Agrega un nuevo vehículo a la base de datos y recarga la lista.
  Future<bool> agregarVehiculo(Vehiculo vehiculo) async {
    try {
      await _repositorio.guardar(vehiculo);
      await cargarVehiculos();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al guardar vehículo: $e');
      return false;
    }
  }

  /// Actualiza un vehículo existente.
  Future<bool> actualizarVehiculo(Vehiculo vehiculo) async {
    try {
      await _repositorio.actualizar(vehiculo);
      await cargarVehiculos();
      // Actualizar el vehículo seleccionado si es el mismo
      if (state.vehiculoSeleccionado?.matricula == vehiculo.matricula) {
        state = state.copyWith(vehiculoSeleccionado: vehiculo);
      }
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al actualizar vehículo: $e');
      return false;
    }
  }

  /// Actualiza el kilometraje del vehículo seleccionado.
  Future<bool> actualizarKilometraje(String matricula, int nuevoKm) async {
    try {
      await _repositorio.actualizarKilometraje(matricula, nuevoKm);
      await cargarVehiculos();
      // Actualiza el vehículo seleccionado con el nuevo km
      if (state.vehiculoSeleccionado?.matricula == matricula) {
        final actualizado = state.vehiculoSeleccionado!.copyWith(
          kilometrajeActual: nuevoKm,
        );
        state = state.copyWith(vehiculoSeleccionado: actualizado);
      }
      
      // Cada vez que se actualiza el km asertivamente, se reprograma 
      // el aviso inteligente de inactividad a 14 días vista.
      await NotificacionesServicio().programarRecordatorioKilometraje();

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al actualizar kilometraje: $e');
      return false;
    }
  }

  /// Elimina un vehículo de la base de datos.
  Future<bool> eliminarVehiculo(String matricula) async {
    try {
      await _repositorio.eliminar(matricula);
      await cargarVehiculos();
      if (state.vehiculoSeleccionado?.matricula == matricula) {
        state = state.copyWith(limpiarVehiculo: true);
      }
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar vehículo: $e');
      return false;
    }
  }
}

/// Provider global del estado de vehículos.
final vehiculoProvider =
    StateNotifierProvider<VehiculoNotifier, EstadoVehiculos>((ref) {
      return VehiculoNotifier(VehiculoRepositorio());
    });

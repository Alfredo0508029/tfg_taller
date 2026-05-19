import '../data/modelos/componente.dart';
import '../data/modelos/vehiculo.dart';
import '../data/modelos/resultado_viaje.dart';

/// Servicio encargado de la lógica de negocio para la simulación de viajes largos.
/// Analiza cómo afectará el kilometraje estimado al mantenimiento de cada pieza.
class LogicaViajeServicio {
  /// Analiza el impacto de un viaje en el estado de mantenimiento del vehículo.
  /// Retorna una lista de [ResultadoViaje] clasificada y ordenada de mayor urgencia a menor.
  List<ResultadoViaje> analizarViaje(
    Vehiculo vehiculo,
    List<Componente> componentes,
    int kmViaje,
  ) {
    final List<ResultadoViaje> resultados = [];

    for (final componente in componentes) {
      // Kilómetros que le quedan de vida útil ahora mismo
      final kmRestantesAct = componente.kmRestantes(vehiculo.kilometrajeActual);
      
      // Vida útil restante si realizamos el viaje planeado
      final kmDespuesViaje = kmRestantesAct - kmViaje;

      EstadoRecomendacion estado;
      String mensaje;

      if (kmDespuesViaje > 3000) {
        estado = EstadoRecomendacion.verde;
        mensaje = '${componente.nombre} estará dentro del rango seguro tras el viaje.';
      } else if (kmDespuesViaje >= 0) {
        estado = EstadoRecomendacion.amarillo;
        mensaje = 'Se recomienda revisar ${componente.nombre.toLowerCase()} antes de salir o durante el viaje.';
      } else {
        estado = EstadoRecomendacion.rojo;
        // Diferenciamos si la pieza ya estaba caducada antes del viaje o caducará durante él
        if (kmRestantesAct < 0) {
          mensaje = '¡Peligro! Debes cambiar ${componente.nombre.toLowerCase()} INMEDIATAMENTE.';
        } else {
          mensaje = 'Debes cambiar ${componente.nombre.toLowerCase()} antes del viaje.';
        }
      }

      resultados.add(
        ResultadoViaje(
          componente: componente,
          kmRestantesActuales: kmRestantesAct,
          kmDespuesViaje: kmDespuesViaje,
          estado: estado,
          mensajeRecomendacion: mensaje,
        ),
      );
    }

    // Ordenamos la lista para mostrar primero lo más crítico:
    // 1. Rojo 2. Amarillo 3. Verde
    resultados.sort((a, b) {
      if (a.estado != b.estado) {
        // b.index > a.index -> rojo(2) > amarillo(1) > verde(0)
        return b.estado.index.compareTo(a.estado.index);
      }
      // En empate, el que tenga menos km restantes después del viaje va primero
      return a.kmDespuesViaje.compareTo(b.kmDespuesViaje);
    });

    return resultados;
  }
}

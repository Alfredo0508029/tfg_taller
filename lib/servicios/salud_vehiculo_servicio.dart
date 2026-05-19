import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/modelos/componente.dart';

/// Enum que representa los tres posibles estados de salud global de un vehículo.
enum EstadoSaludVehiculo {
  bueno,     // 80-100%
  revisar,   // 50-79%
  critico,   // 0-49%
}

/// Modelo de datos inmutable que envuelve el resultado del análisis de salud.
class ReporteSalud {
  final double porcentaje;
  final EstadoSaludVehiculo estado;
  final List<Componente> componentesCriticos; // Rojos (km < 0)
  final List<Componente> componentesAdvertencia; // Amarillos (0 <= km < 2000)

  const ReporteSalud({
    required this.porcentaje,
    required this.estado,
    required this.componentesCriticos,
    required this.componentesAdvertencia,
  });

  /// Devuelve un color semántico para la interfaz basado en el estado.
  Color get color {
    switch (estado) {
      case EstadoSaludVehiculo.bueno:
        return Colors.green;
      case EstadoSaludVehiculo.revisar:
        return Colors.orange;
      case EstadoSaludVehiculo.critico:
        return Colors.red;
    }
  }

  /// Devuelve un mensaje de estado genérico (para depuración).
  String get mensaje => estado.name;
}

/// Servicio encargado de evaluar el estado global del vehículo basándose
/// en la salud individual de sus componentes mecánicos.
class SaludVehiculoServicio {
  
  /// Calcula el reporte de salud porcentual y cualitativo de un vehículo.
  /// 
  /// - Verde (km > 2000): 100 puntos
  /// - Amarillo (0 <= km <= 2000): 50 puntos
  /// - Rojo (km < 0): 0 puntos
  ReporteSalud calcularSaludGlobal(List<Componente> componentes, int kilometrajeActual) {
    if (componentes.isEmpty) {
      // Si no hay componentes registrados, asumimos salud perfecta o nula. 
      // Lo ideal es devolver 100% para no asustar, pero sin piezas críticas.
      return const ReporteSalud(
        porcentaje: 100.0,
        estado: EstadoSaludVehiculo.bueno,
        componentesCriticos: [],
        componentesAdvertencia: [],
      );
    }

    double puntuacionTotal = 0.0;
    final criticos = <Componente>[];
    final advertencias = <Componente>[];

    for (final componente in componentes) {
      final kmRestantes = componente.kmRestantes(kilometrajeActual);

      if (kmRestantes <= 0) {
        // Componente retrasado en mantenimiento (ROJO) -> 0 puntos
        criticos.add(componente);
      } else if (kmRestantes <= 2000) {
        // Componente próximo a necesitar mantenimiento (AMARILLO) -> 50 puntos
        advertencias.add(componente);
        puntuacionTotal += 50.0;
      } else {
        // Componente en buen estado (VERDE) -> 100 puntos
        puntuacionTotal += 100.0;
      }
    }

    // Calculamos el porcentaje como la media matemática de las puntuaciones
    double porcentajeSalud = puntuacionTotal / componentes.length;

    // Si hay algún componente crítico, capamos la salud máxima al 49%
    // para que el estado visual (Rojo) sea coherente con el porcentaje.
    if (criticos.isNotEmpty && porcentajeSalud >= 50.0) {
      porcentajeSalud = 49.0;
    }

    // Asignamos el calificador global
    EstadoSaludVehiculo estadoCalculado;
    if (criticos.isNotEmpty) {
      // Prioridad absoluta: si hay un fallo, el coche no está 'Bueno' ni para 'Revisar'
      estadoCalculado = EstadoSaludVehiculo.critico;
    } else if (porcentajeSalud >= 80.0) {
      estadoCalculado = EstadoSaludVehiculo.bueno;
    } else if (porcentajeSalud >= 50.0) {
      estadoCalculado = EstadoSaludVehiculo.revisar;
    } else {
      estadoCalculado = EstadoSaludVehiculo.critico;
    }

    return ReporteSalud(
      porcentaje: porcentajeSalud,
      estado: estadoCalculado,
      componentesCriticos: criticos,
      componentesAdvertencia: advertencias,
    );
  }
}

/// Provider de Riverpod para inyectar este servicio globalmente de forma limpia
final saludVehiculoServicioProvider = Provider<SaludVehiculoServicio>((ref) {
  return SaludVehiculoServicio();
});

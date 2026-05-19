import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/modelos/repostaje.dart';
import '../data/modelos/vehiculo.dart';

/// Resultado de los cálculos de consumo para mostrar en la interfaz.
class MetricasConsumo {
  final double consumoMedioGlobal;
  final double costePorKm;
  final String unidadMedida; // Ej: "L/100km" o "kWh/100km"
  final Map<String, double> consumoPorRepostajeId;

  MetricasConsumo({
    required this.consumoMedioGlobal,
    required this.costePorKm,
    required this.unidadMedida,
    required this.consumoPorRepostajeId,
  });
}

/// Servicio dedicado a calcular rendimientos del vehículo.
class ConsumoServicio {
  /// Obtiene la etiqueta textual para el consumo.
  String obtenerUnidad(String tipoCarburante) {
    if (tipoCarburante.toLowerCase() == 'eléctrico') {
      return 'kWh/100km';
    }
    return 'L/100km';
  }

  /// Realiza todos los cálculos relevantes en base al historial de repostajes.
  /// Asume que [repostajes] viene ordenado de más reciente a más antiguo
  /// (como devuelve el Repositorio de Supabase).
  MetricasConsumo calcularMetricas(
      List<Repostaje> repostajes, Vehiculo vehiculo) {
    if (repostajes.length < 2) {
      // Si hay 1 o 0 repostajes, no podemos calcular un consumo real (falta diferencia de km).
      return MetricasConsumo(
        consumoMedioGlobal: 0.0,
        costePorKm: 0.0,
        unidadMedida: obtenerUnidad(vehiculo.tipoCarburante),
        consumoPorRepostajeId: {},
      );
    }

    double totalLitros = 0;
    double totalGastado = 0;
    Map<String, double> consumosIndividuales = {};

    // El primer repostaje no puede calcular su propio consumo hacia atrás,
    // así que empezamos teniendo en cuenta los tramos.
    // Como lista[i] es más actual que lista[i+1]:
    for (int i = 0; i < repostajes.length - 1; i++) {
      final actual = repostajes[i]; // Más nuevo
      final anterior = repostajes[i + 1]; // Más viejo

      final kmRecorridos = actual.kilometraje - anterior.kilometraje;

      if (kmRecorridos > 0) {
        // Consumo de este tramo: (Litros / Km) * 100
        final consumoTramo = (actual.litros / kmRecorridos) * 100;
        consumosIndividuales[actual.id!] = consumoTramo;
      } else {
        consumosIndividuales[actual.id!] = 0.0;
      }
    }

    // Para la media global tomamos: (Suma de litros repostados en los tramos medibles) / (Km Totales medibles) * 100.
    // El litro del repostaje más antiguo NO se debe sumar porque no sabemos cuántos km duró.
    int kmTotalesMedibles =
        repostajes.first.kilometraje - repostajes.last.kilometraje;

    for (int i = 0; i < repostajes.length - 1; i++) {
      totalLitros += repostajes[i].litros;
    }

    for (var r in repostajes) {
      totalGastado += r.precioTotal;
    }

    double consumoMedioGlobal = 0.0;
    double costePorKm = 0.0;

    if (kmTotalesMedibles > 0) {
      consumoMedioGlobal = (totalLitros / kmTotalesMedibles) * 100;
      costePorKm = totalGastado / kmTotalesMedibles;
    }

    return MetricasConsumo(
      consumoMedioGlobal: consumoMedioGlobal,
      costePorKm: costePorKm,
      unidadMedida: obtenerUnidad(vehiculo.tipoCarburante),
      consumoPorRepostajeId: consumosIndividuales,
    );
  }
}

final consumoServicioProvider = Provider((ref) => ConsumoServicio());

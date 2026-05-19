import 'package:flutter/material.dart';

/// Define los colores para los estados de mantenimiento (verde, amarillo, rojo).
class ColoresEstado {
  /// Estado OK: Queda más del 20% del intervalo.
  static const Color ok = Colors.green;

  /// Estado Próximo: Queda menos del 20% del intervalo.
  static const Color proximo = Colors.orange;

  /// Estado Urgente: Se ha superado el intervalo de cambio.
  static const Color urgente = Colors.red;

  /// Determina el color en base a los kilómetros restantes y el intervalo total.
  static Color obtenerColor(int kmRestantes, int intervaloTotal) {
    if (kmRestantes <= 0) return urgente;

    // Si queda menos del 20% del intervalo (o menos de 1000km), es "próximo"
    final umbralProximo = (intervaloTotal * 0.2).clamp(0, 1000).toInt();
    if (kmRestantes <= umbralProximo) return proximo;

    return ok;
  }
}

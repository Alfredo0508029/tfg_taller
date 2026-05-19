import 'package:flutter/material.dart';
import 'componente.dart';

/// Enum que categoriza el estado del componente tras el viaje estimado.
enum EstadoRecomendacion {
  verde,
  amarillo,
  rojo,
}

extension EstadoRecomendacionExt on EstadoRecomendacion {
  /// Color asociado al estado para la interfaz gráfica.
  Color get colorVisual {
    switch (this) {
      case EstadoRecomendacion.verde:
        return Colors.green;
      case EstadoRecomendacion.amarillo:
        return Colors.orange;
      case EstadoRecomendacion.rojo:
        return Colors.red;
    }
  }

  /// Icono asociado al estado para la interfaz gráfica.
  IconData get iconoVisual {
    switch (this) {
      case EstadoRecomendacion.verde:
        return Icons.check_circle;
      case EstadoRecomendacion.amarillo:
        return Icons.warning;
      case EstadoRecomendacion.rojo:
        return Icons.dangerous;
    }
  }
}

/// Representa el resultado del análisis predictivo para un componente específico.
class ResultadoViaje {
  final Componente componente;
  final int kmRestantesActuales;
  final int kmDespuesViaje;
  final EstadoRecomendacion estado;
  final String mensajeRecomendacion;

  const ResultadoViaje({
    required this.componente,
    required this.kmRestantesActuales,
    required this.kmDespuesViaje,
    required this.estado,
    required this.mensajeRecomendacion,
  });
}

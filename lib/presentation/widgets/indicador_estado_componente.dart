import 'package:flutter/material.dart';
import '../../core/constantes/colores_estado.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

/// Un pequeño widget (Chip) que muestra visualmente el estado
/// de un componente (OK, Próximo, Urgente) basado en los km restantes.
class IndicadorEstadoComponente extends StatelessWidget {
  /// Kilómetros restantes para el próximo cambio.
  final int kmRestantes;

  /// Intervalo total en kilómetros del componente.
  final int intervaloTotal;

  const IndicadorEstadoComponente({
    super.key,
    required this.kmRestantes,
    required this.intervaloTotal,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColoresEstado.obtenerColor(kmRestantes, intervaloTotal);
    final l10n = AppLocalizations.of(context)!;

    String textoEstado;
    IconData icono;

    if (color == ColoresEstado.ok) {
      textoEstado = l10n.okStatus;
      icono = Icons.check_circle;
    } else if (color == ColoresEstado.proximo) {
      textoEstado = l10n.upcomingStatus;
      icono = Icons.warning;
    } else {
      textoEstado = l10n.urgentStatus;
      icono = Icons.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            textoEstado,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

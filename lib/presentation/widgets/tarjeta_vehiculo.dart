import 'package:flutter/material.dart';
import '../../data/modelos/vehiculo.dart';

/// Widget que representa un vehículo en la lista de la pantalla principal.
/// Muestra la fotografía del vehículo si está disponible,
/// o un icono genérico de coche como alternativa visual.
class TarjetaVehiculo extends StatelessWidget {
  final Vehiculo vehiculo;
  final VoidCallback onTap;

  const TarjetaVehiculo({
    super.key,
    required this.vehiculo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        label: 'Vehículo: ${vehiculo.nombreCompleto}, Kilometraje: ${vehiculo.kilometrajeActual} kilómetros, Matrícula: ${vehiculo.matricula ?? "Sin matrícula"}',
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // ── Avatar del vehículo ─────────────────────────────────────
                // Si existe una URL de imagen, la mostramos; si no, usamos el icono
                _avatarVehiculo(theme),
                const SizedBox(width: 16),

                // ── Datos principales del vehículo ──────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehiculo.nombreCompleto,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                            semanticLabel: 'Kilometraje:',
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vehiculo.kilometrajeActual} km',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          // Indicador visual de que el vehículo tiene foto adjunta
                          if (vehiculo.imagenUrl != null) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.photo_camera,
                              size: 14,
                              color: theme.colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ],
                        ],
                      ),
                      // Matrícula como datos secundarios
                      if (vehiculo.matricula != null)
                        Text(
                          vehiculo.matricula!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                            letterSpacing: 1.2,
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Flecha de navegación ────────────────────────────────────
                const Icon(Icons.chevron_right, semanticLabel: 'Ver detalles'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el avatar circular del vehículo.
  /// Prioriza la imagen de red; si no existe, muestra el icono genérico.
  Widget _avatarVehiculo(ThemeData theme) {
    if (vehiculo.imagenUrl != null && vehiculo.imagenUrl!.isNotEmpty) {
      // Avatar con la foto real del vehículo descargada de Supabase Storage
      return ClipOval(
        child: SizedBox(
          width: 56,
          height: 56,
          child: Image.network(
            vehiculo.imagenUrl!,
            fit: BoxFit.cover,
            // Placeholder mientras carga
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : _iconoGenerico(theme),
            // Fallback si falla la carga
            errorBuilder: (_, __, ___) => _iconoGenerico(theme),
          ),
        ),
      );
    }
    // Sin imagen: icono de coche sobre fondo de color primario
    return _iconoGenerico(theme);
  }

  /// Icono genérico de coche para cuando no hay fotografía disponible.
  Widget _iconoGenerico(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.directions_car,
        size: 32,
        color: theme.colorScheme.onPrimaryContainer,
        semanticLabel: 'Icono de coche',
      ),
    );
  }
}

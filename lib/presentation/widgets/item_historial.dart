import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';
import '../../data/modelos/registro_mantenimiento.dart';

/// Widget que muestra un elemento individual del historial de mantenimiento.
/// Si el registro tiene una imagen adjunta, muestra una miniatura expandible
/// que el usuario puede tocar para ver a pantalla completa.
class ItemHistorial extends StatelessWidget {
  final RegistroMantenimiento registro;
  final VoidCallback? onDelete;

  const ItemHistorial({super.key, required this.registro, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Formateamos la fecha de forma amigable (ej: 15 oct. 2023)
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    );
    final fechaStr = dateFormat.format(registro.fecha);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Información principal del registro ───────────────────────────
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_circle,
                color: theme.colorScheme.onSecondaryContainer,
                semanticLabel: 'Icono de reparación',
              ),
            ),
            title: Text(
              registro.nombreComponente,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Fila de fecha y kilometraje
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                      semanticLabel: 'Fecha:',
                    ),
                    const SizedBox(width: 4),
                    Text(fechaStr),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.speed,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                      semanticLabel: 'Kilometraje:',
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${registro.kilometraje} km',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Notas del registro (si existen)
                if (registro.notas != null && registro.notas!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notes,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                          semanticLabel: 'Notas:',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            registro.notas!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            trailing: onDelete != null
                ? IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: onDelete,
                    tooltip: l10n.delete,
                  )
                : null,
          ),

          // ── Imagen del mantenimiento (si existe) ─────────────────────────
          // Si el registro tiene URL de imagen, mostramos la miniatura debajo
          if (registro.imagenUrl != null && registro.imagenUrl!.isNotEmpty)
            _MiniaturaMantenimiento(urlImagen: registro.imagenUrl!),
        ],
      ),
    );
  }
}

/// Widget auxiliar que muestra la foto adjunta al registro de mantenimiento.
/// Al hacer tap, abre la imagen a pantalla completa con zoom interactivo.
class _MiniaturaMantenimiento extends StatelessWidget {
  final String urlImagen;

  const _MiniaturaMantenimiento({required this.urlImagen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Al tocar la miniatura se abre el visor a pantalla completa
      onTap: () => _mostrarImagenCompleta(context),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        child: SizedBox(
          height: 160,
          child: Image.network(
            urlImagen,
            fit: BoxFit.cover,
            // Indicador de carga mientras se descarga la imagen de red
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : Container(
                    height: 160,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
            // Placeholder de error si la imagen no se puede cargar
            errorBuilder: (_, __, ___) => Container(
              height: 100,
              color: Theme.of(context).colorScheme.errorContainer,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Abre un diálogo con la imagen a pantalla completa.
  /// El usuario puede hacer pinch-to-zoom gracias a [InteractiveViewer].
  void _mostrarImagenCompleta(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            // Imagen con zoom interactivo centrada en la pantalla
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  urlImagen,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Botón de cierre del visor
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
                tooltip: AppLocalizations.of(context)!.closeImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/vehiculo_provider.dart';
import '../../../providers/mantenimiento_provider.dart';
import '../../widgets/item_historial.dart';

/// Pantalla que muestra el historial completo de mantenimientos de un vehículo.
class HistorialPantalla extends ConsumerStatefulWidget {
  const HistorialPantalla({super.key});

  @override
  ConsumerState<HistorialPantalla> createState() => _HistorialPantallaState();
}

class _HistorialPantallaState extends ConsumerState<HistorialPantalla> {
  @override
  void initState() {
    super.initState();
    // Cargar historial al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
      if (vehiculo != null) {
        ref.read(mantenimientoProvider.notifier).cargarHistorial(vehiculo.matricula!);
      }
    });
  }

  Future<void> _eliminarRegistro(
    String id,
    String vehiculoMatricula,
    AppLocalizations l10n,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteMaintenanceConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      await ref
          .read(mantenimientoProvider.notifier)
          .eliminarRegistro(id, vehiculoMatricula);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiculo = ref.watch(vehiculoProvider).vehiculoSeleccionado;
    final estadoHistorial = ref.watch(mantenimientoProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (vehiculo == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: estadoHistorial.cargando
          ? const Center(child: CircularProgressIndicator())
          : estadoHistorial.registros.isEmpty
          ? _buildListaVacia(context, vehiculo.matricula!, l10n, theme)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: estadoHistorial.registros.length,
              itemBuilder: (context, index) {
                final registro = estadoHistorial.registros[index];
                return ItemHistorial(
                  registro: registro,
                  onDelete: () =>
                      _eliminarRegistro(registro.id!, vehiculo.matricula!, l10n),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/vehiculo/${vehiculo.matricula}/historial/registrar'),
        tooltip: l10n.registerMaintenance,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListaVacia(
    BuildContext context,
    String vehiculoMatricula,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noHistory,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                context.push('/vehiculo/$vehiculoMatricula/historial/registrar'),
            icon: const Icon(Icons.add),
            label: Text(l10n.registerMaintenance),
          ),
        ],
      ),
    );
  }
}

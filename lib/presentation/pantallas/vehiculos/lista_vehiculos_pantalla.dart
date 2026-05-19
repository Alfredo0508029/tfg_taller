import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/vehiculo_provider.dart';
import '../../widgets/tarjeta_vehiculo.dart';

/// Pantalla principal (Home) que muestra la lista de vehículos guardados.
class ListaVehiculosPantalla extends ConsumerWidget {
  const ListaVehiculosPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el estado global de vehículos
    final estadoVehiculos = ref.watch(vehiculoProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/ajustes'),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: estadoVehiculos.cargando
          ? const Center(child: CircularProgressIndicator())
          : estadoVehiculos.vehiculos.isEmpty
          ? _buildListaVacia(context, l10n, theme)
          : ListView.builder(
              itemCount: estadoVehiculos.vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = estadoVehiculos.vehiculos[index];
                return TarjetaVehiculo(
                  vehiculo: vehiculo,
                  onTap: () {
                    // Al tocar, lo marcamos como seleccionado y vamos al dashboard
                    ref
                        .read(vehiculoProvider.notifier)
                        .seleccionarVehiculo(vehiculo);
                    context.go('/vehiculo/${vehiculo.matricula}');
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/nuevo-vehiculo'),
        tooltip: l10n.addVehicle,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Construye la vista cuando no hay vehículos registrados.
  Widget _buildListaVacia(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noVehicles,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/nuevo-vehiculo'),
            icon: const Icon(Icons.add),
            label: Text(l10n.addVehicle),
          ),
        ],
      ),
    );
  }
}

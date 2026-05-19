import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/vehiculo_provider.dart';
import '../../../providers/componente_provider.dart';
import '../../widgets/indicador_estado_componente.dart';

/// Lista de los componentes que tiene registrados un vehículo.
class ListaComponentesPantalla extends ConsumerStatefulWidget {
  const ListaComponentesPantalla({super.key});

  @override
  ConsumerState<ListaComponentesPantalla> createState() =>
      _ListaComponentesPantallaState();
}

class _ListaComponentesPantallaState
    extends ConsumerState<ListaComponentesPantalla> {
  @override
  void initState() {
    super.initState();
    // Carga inicial de componentes al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
      if (vehiculo != null) {
        ref.read(componenteProvider.notifier).cargarComponentes(vehiculo.matricula!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehiculo = ref.watch(vehiculoProvider).vehiculoSeleccionado;
    final estadoComponentes = ref.watch(componenteProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (vehiculo == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.components),
        actions: [
          // Botón para añadir un nuevo componente
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                context.push('/vehiculo/${vehiculo.matricula}/componentes/nuevo'),
            tooltip: l10n.addComponent,
          ),
        ],
      ),
      body: estadoComponentes.cargando
          ? const Center(child: CircularProgressIndicator())
          : estadoComponentes.componentes.isEmpty
          ? _buildListaVacia(context, vehiculo.matricula!, l10n, theme)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: estadoComponentes.componentes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final comp = estadoComponentes.componentes[index];
                final kmRestantes = comp.kmRestantes(
                  vehiculo.kilometrajeActual,
                );

                return Card(
                  child: ListTile(
                    onTap: () => context.push(
                      '/vehiculo/${vehiculo.matricula}/componentes/editar',
                      extra: comp,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.settings_suggest,
                        color: theme.colorScheme.onTertiaryContainer,
                        semanticLabel: 'Estado del componente',
                      ),
                    ),
                    title: Text(
                      comp.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          kmRestantes >= 0
                              ? l10n.remainingKm(kmRestantes.toString())
                              : l10n.overdueKm(kmRestantes.abs().toString()),
                        ),
                      ],
                    ),
                    trailing: IndicadorEstadoComponente(
                      kmRestantes: kmRestantes,
                      intervaloTotal: comp.intervaloKm,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildListaVacia(
    BuildContext context,
    String vehiculoId,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.components,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                context.push('/vehiculo/$vehiculoId/componentes/nuevo'),
            icon: const Icon(Icons.add),
            label: Text(l10n.addComponent),
          ),
        ],
      ),
    );
  }
}

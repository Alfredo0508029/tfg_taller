import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/vehiculo_provider.dart';
import '../../../providers/repostaje_provider.dart';
import '../../../servicios/consumo_servicio.dart';

class RepostajesPantalla extends ConsumerStatefulWidget {
  const RepostajesPantalla({super.key});

  @override
  ConsumerState<RepostajesPantalla> createState() => _RepostajesPantallaState();
}

class _RepostajesPantallaState extends ConsumerState<RepostajesPantalla> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
      if (vehiculo != null) {
        ref.read(repostajeProvider.notifier).cargarRepostajes(vehiculo.matricula!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehiculo = ref.watch(vehiculoProvider).vehiculoSeleccionado;
    final estadoRepostajes = ref.watch(repostajeProvider);
    final consumoServicio = ref.watch(consumoServicioProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (vehiculo == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.consumptionAndRefuels)),
        body: Center(child: Text(l10n.selectVehicleFirst)),
      );
    }

    final metricas = consumoServicio.calcularMetricas(
      estadoRepostajes.repostajes,
      vehiculo,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.consumptionAndRefuels),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/vehiculo/${vehiculo.matricula}/repostajes/registrar'),
            tooltip: l10n.addRefuel,
          ),
        ],
      ),
      body: estadoRepostajes.cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Tarjeta Principal de Consumo Global ────────────
                  _buildTarjetaConsumo(metricas, theme, vehiculo.tipoCarburante, l10n),
                  const SizedBox(height: 16),

                  // ── Tarjeta de Coste por km ────────────────────────
                  _buildTarjetaCostoKm(metricas.costePorKm, theme, l10n),
                  const SizedBox(height: 24),

                  // ── Título del historial ───────────────────────────
                  Text(
                    l10n.refuelHistory,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Historial de Repostajes ────────────────────────
                  if (estadoRepostajes.repostajes.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.local_gas_station_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noRefuelsYet,
                                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: estadoRepostajes.repostajes.length,
                      itemBuilder: (ctx, i) {
                        final rep = estadoRepostajes.repostajes[i];
                        final consumoTramo = metricas.consumoPorRepostajeId[rep.id!] ?? 0.0;
                        return _buildItemRepostaje(rep, consumoTramo, metricas.unidadMedida, theme, context, l10n);
                      },
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehiculo/${vehiculo.matricula}/repostajes/registrar'),
        tooltip: l10n.addRefuel,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTarjetaConsumo(MetricasConsumo metricas, ThemeData theme, String tipoCarburante, AppLocalizations l10n) {
    bool esElectrico = tipoCarburante.toLowerCase() == 'eléctrico';

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Icon(
              esElectrico ? Icons.electric_car : Icons.local_gas_station,
              size: 48,
              color: theme.colorScheme.onPrimaryContainer,
              semanticLabel: esElectrico ? 'Icono de coche eléctrico' : 'Icono de gasolinera',
            ),
            const SizedBox(height: 16),
            Text(
              l10n.globalAverageConsumption,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  metricas.consumoMedioGlobal.toStringAsFixed(1),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  metricas.unidadMedida,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaCostoKm(double costoPorKm, ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.euro, 
                color: theme.colorScheme.onSecondaryContainer,
                semanticLabel: 'Icono de moneda',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.costPerKm,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${costoPorKm.toStringAsFixed(3)} €/km',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRepostaje(
    dynamic rep,
    double consumoTramo,
    String unidad,
    ThemeData theme,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.water_drop, 
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
        title: Text('${rep.precioTotal.toStringAsFixed(2)} €'),
        subtitle: Text('${dateFormat.format(rep.fecha)} - ${rep.kilometraje} km'),
        childrenPadding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DatoRepostajePeque(
                titulo: l10n.amount,
                valor: '${rep.litros.toStringAsFixed(2)} ${unidad.split('/').first}',
                theme: theme,
              ),
              _DatoRepostajePeque(
                titulo: l10n.segmentConsumption,
                valor: consumoTramo > 0 ? '${consumoTramo.toStringAsFixed(1)} $unidad' : '- $unidad',
                theme: theme,
              ),
              _DatoRepostajePeque(
                titulo: l10n.unitPrice,
                valor: rep.precioPorLitro != null ? '${rep.precioPorLitro!.toStringAsFixed(3)} €' : '-',
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                icon: const Icon(Icons.delete, size: 18),
                label: Text(l10n.delete),
                onPressed: () => _eliminarRepostaje(rep.id!, context, l10n),
             ),
          )
        ],
      ),
    );
  }

  Future<void> _eliminarRepostaje(String id, BuildContext context, AppLocalizations l10n) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteRefuel),
        content: Text(l10n.deleteRefuelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true), 
            child: Text(l10n.delete)
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final rutMat = ref.read(vehiculoProvider).vehiculoSeleccionado!.matricula!;
      await ref.read(repostajeProvider.notifier).eliminarRepostaje(id, rutMat);
    }
  }
}

class _DatoRepostajePeque extends StatelessWidget {
  final String titulo;
  final String valor;
  final ThemeData theme;

  const _DatoRepostajePeque({required this.titulo, required this.valor, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(valor, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

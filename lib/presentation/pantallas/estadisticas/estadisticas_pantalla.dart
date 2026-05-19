import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/vehiculo_provider.dart';
import '../../../providers/mantenimiento_provider.dart';
import '../../../providers/repostaje_provider.dart';
// import 'package:fl_chart/fl_chart.dart'; // En el plan, aunque a veces recomienda simplificar. Se usa para las gráficas si hay tiempo.

/// Pantalla de Estadísticas del vehículo seleccionado.
class EstadisticasPantalla extends ConsumerStatefulWidget {
  const EstadisticasPantalla({super.key});

  @override
  ConsumerState<EstadisticasPantalla> createState() =>
      _EstadisticasPantallaState();
}

class _EstadisticasPantallaState extends ConsumerState<EstadisticasPantalla> {
  Map<String, dynamic>? _estadisticas;
  double _dineroMantenimientos = 0.0;
  double _dineroRepostajes = 0.0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarStats();
  }

  Future<void> _cargarStats() async {
    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
    if (vehiculo != null) {
      final stats = await ref
          .read(mantenimientoProvider.notifier)
          .obtenerEstadisticas(vehiculo.matricula!);
          
      // Recopilar el dinero total de mantenimientos
      final listaMant = await ref.read(mantenimientoProvider.notifier).obtenerTodosMantenimientosParaStats(vehiculo.matricula!);
      double totalMant = 0;
      for (var m in listaMant) {
        if (m.precio != null) totalMant += m.precio!;
      }

      // Recopilar dinero total de repostajes
      await ref.read(repostajeProvider.notifier).cargarRepostajes(vehiculo.matricula!);
      final listaRep = ref.read(repostajeProvider).repostajes;
      double totalRep = 0;
      for (var r in listaRep) {
        totalRep += r.precioTotal;
      }

      if (mounted) {
        setState(() {
          _estadisticas = stats;
          _dineroMantenimientos = totalMant;
          _dineroRepostajes = totalRep;
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.statistics)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totalMantenimientos = _estadisticas?['total'] as int? ?? 0;
    final frecuentes =
        _estadisticas?['frecuentes'] as List<Map<String, dynamic>>? ?? [];
    final hayDatos = totalMantenimientos > 0 || _dineroRepostajes > 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: !hayDatos
          ? Center(child: Text(l10n.noData))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tarjeta Super-Destacada Dinero Invertido
                  _buildTarjetaDineroTotal(theme, l10n),
                  const SizedBox(height: 24),

                  // KPI Principal (solo si hay mantenimientos)
                  if (totalMantenimientos > 0) ...[
                    Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.insights,
                              size: 48,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              totalMantenimientos.toString(),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              l10n.totalMaintenances,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lista de más frecuentes
                    Text(
                      l10n.frequentComponents,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: frecuentes.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = frecuentes[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            title: Text(item['nombre_componente'] as String),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item['total']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildTarjetaDineroTotal(ThemeData theme, AppLocalizations l10n) {
    final double totalInvertido = _dineroMantenimientos + _dineroRepostajes;
    return Card(
      elevation: 0,
      color: theme.colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              l10n.totalMoneyInverted,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.bold,
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
                  totalInvertido.toStringAsFixed(2),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '€',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Column(
                   children: [
                     Icon(Icons.build, size: 20, color: theme.colorScheme.onTertiaryContainer),
                     const SizedBox(height: 4),
                     Text('${_dineroMantenimientos.toStringAsFixed(2)} €', style: TextStyle(color: theme.colorScheme.onTertiaryContainer, fontWeight: FontWeight.bold)),
                   ]
                 ),
                 Column(
                   children: [
                     Icon(Icons.local_gas_station, size: 20, color: theme.colorScheme.onTertiaryContainer),
                     const SizedBox(height: 4),
                     Text('${_dineroRepostajes.toStringAsFixed(2)} €', style: TextStyle(color: theme.colorScheme.onTertiaryContainer, fontWeight: FontWeight.bold)),
                   ]
                 ),
               ]
            )
          ],
        ),
      ),
    );
  }
}


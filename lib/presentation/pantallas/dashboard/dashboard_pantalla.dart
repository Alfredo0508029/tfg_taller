import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/vehiculo_provider.dart';
import '../../../providers/componente_provider.dart';
import '../../../providers/notificaciones_provider.dart';
import '../../../servicios/salud_vehiculo_servicio.dart';

/// Pantalla principal (Dashboard) para un vehículo específico.
class DashboardPantalla extends ConsumerStatefulWidget {
  const DashboardPantalla({super.key});

  @override
  ConsumerState<DashboardPantalla> createState() => _DashboardPantallaState();
}

class _DashboardPantallaState extends ConsumerState<DashboardPantalla> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
      if (vehiculo != null) {
        ref.read(componenteProvider.notifier).cargarComponentes(vehiculo.matricula!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el vehículo seleccionado del estado global
    final vehiculo = ref.watch(vehiculoProvider).vehiculoSeleccionado;
    final estadoComponentes = ref.watch(componenteProvider);
    final saludServicio = ref.watch(saludVehiculoServicioProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Protección en caso de que se navegue aquí sin un vehículo válido
    if (vehiculo == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.dashboard)),
        body: Center(child: Text(l10n.vehicleNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vehiculo.marca),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/editar-vehiculo', extra: vehiculo),
            tooltip: l10n.editVehicle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Evaluamos la salud en tiempo real
            Builder(
              builder: (ctx) {
                final reporteSalud = saludServicio.calcularSaludGlobal(
                  estadoComponentes.componentes,
                  vehiculo.kilometrajeActual,
                );

                // Riverpod listener para disparar la notificación médica en segundo plano 
                // sin interrumpir la renderización (seguro porque _deboNotificar evita el spam).
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!estadoComponentes.cargando && estadoComponentes.componentes.isNotEmpty) {
                    final notifServicio = ref.read(notificacionesServicioProvider);
                    // 1. Verificar salud global (resumen)
                    notifServicio.verificarSaludVehiculo(reporteSalud, vehiculo.matricula!);
                    // 2. Verificar componentes individuales (alertas específicas)
                    notifServicio.verificarComponentes(estadoComponentes.componentes, vehiculo.kilometrajeActual, vehiculo.matricula!);
                  }
                });

                // Resumen de estado principal
                return Column(
                  children: [
                    _buildResumenHeader(context, vehiculo, reporteSalud, theme, l10n),
                    if (reporteSalud.componentesCriticos.isNotEmpty ||
                        reporteSalud.componentesAdvertencia.isNotEmpty)
                      _buildDiagnosticoSalud(context, reporteSalud, theme, l10n),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Rejilla de botones de navegación (Dashboard options)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildBotonDashboard(
                  context: context,
                  titulo: l10n.components,
                  icono: Icons.build,
                  color: Colors.blue,
                  ruta: '/vehiculo/${vehiculo.matricula}/componentes',
                ),
                _buildBotonDashboard(
                  context: context,
                  titulo: l10n.history,
                  icono: Icons.history,
                  color: Colors.purple,
                  ruta: '/vehiculo/${vehiculo.matricula}/historial',
                ),
                _buildBotonDashboard(
                  context: context,
                  titulo: l10n.statistics,
                  icono: Icons.bar_chart,
                  color: Colors.orange,
                  ruta: '/vehiculo/${vehiculo.matricula}/estadisticas',
                ),
                _buildBotonDashboard(
                  context: context,
                  titulo: l10n.registerMaintenance,
                  icono: Icons.add_task,
                  color: Colors.green,
                  ruta: '/vehiculo/${vehiculo.matricula}/historial/registrar',
                ),
                _buildBotonDashboard(
                  context: context,
                  titulo: l10n.tripSimulator,
                  icono: Icons.mode_of_travel,
                  color: Colors.teal,
                  ruta: '/vehiculo/${vehiculo.matricula}/simulador-viaje',
                ),
                _buildBotonDashboard(
                  context: context,
                  titulo: l10n.consumptionAndRefuels,
                  icono: Icons.local_gas_station,
                  color: const Color(0xFF689F38), // Verde Oliva
                  ruta: '/vehiculo/${vehiculo.matricula}/repostajes',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la cabecera vistosa con el modelo y kilometraje.
  Widget _buildResumenHeader(
    BuildContext context,
    dynamic vehiculo,
    ReporteSalud reporteSalud,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              vehiculo.modelo,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${vehiculo.anio}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. Salud del vehículo (Izquierda)
                Semantics(
                  label: '${l10n.healthDiagnosis}: ${reporteSalud.porcentaje.toStringAsFixed(0)}%, ${
                    switch (reporteSalud.estado) {
                      EstadoSaludVehiculo.bueno => l10n.goodHealth,
                      EstadoSaludVehiculo.revisar => l10n.checkHealth,
                      EstadoSaludVehiculo.critico => l10n.urgentHealth,
                    }
                  }',
                  child: _buildIndicadorSalud(reporteSalud, theme, l10n),
                ),

                // Separador visual
                Container(
                  height: 60,
                  width: 1,
                  color: theme.colorScheme.outlineVariant,
                ),

                // 2. Kilometraje (Derecha)
                Expanded(
                  child: Semantics(
                    label: '${l10n.currentMileage}: ${vehiculo.kilometrajeActual} km',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.speed, 
                          size: 30, 
                          color: theme.colorScheme.secondary,
                          // semanticLabel ya no es necesario aquí si el padre Semantics lo cubre, 
                          // pero lo mantenemos consistente con el resto de la app
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.currentMileage,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${vehiculo.kilometrajeActual} km',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el porcentaje y calificador (Bueno, Regular, Crítico).
  Widget _buildIndicadorSalud(ReporteSalud reporte, ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: reporte.porcentaje / 100.0,
                color: reporte.color,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                strokeWidth: 8,
                semanticsLabel: '${l10n.healthDiagnosis}: ${reporte.porcentaje.toStringAsFixed(0)}%',
              ),
            ),
            Text(
              '${reporte.porcentaje.toStringAsFixed(0)}%',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: reporte.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          switch (reporte.estado) {
            EstadoSaludVehiculo.bueno => l10n.goodHealth,
            EstadoSaludVehiculo.revisar => l10n.checkHealth,
            EstadoSaludVehiculo.critico => l10n.urgentHealth,
          },
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: reporte.color,
          ),
        ),
      ],
    );
  }


  /// Sección que lista las piezas que necesitan atención inmediata.
  Widget _buildDiagnosticoSalud(
    BuildContext context,
    ReporteSalud reporte,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final todosIncidencias = [
      ...reporte.componentesCriticos,
      ...reporte.componentesAdvertencia
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics_outlined,
                      size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.healthDiagnosis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...todosIncidencias.take(3).map((comp) {
                final esCritico = reporte.componentesCriticos.contains(comp);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        esCritico ? Icons.error : Icons.warning,
                        color: esCritico ? Colors.red : Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          comp.nombre,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        esCritico ? l10n.urgentStatus : l10n.upcomingStatus,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: esCritico ? Colors.red : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (todosIncidencias.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    l10n.moreAlerts(todosIncidencias.length - 3),
                    style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye una tarjeta clickable para las opciones del dashboard.
  Widget _buildBotonDashboard({
    required BuildContext context,
    required String titulo,
    required IconData icono,
    required Color color,
    required String ruta,
  }) {
    final theme = Theme.of(context);
    // Un color claro para el fondo basado en el color principal del botón
    final bgColor = theme.brightness == Brightness.light
        ? color.withValues(alpha: 0.1)
        : color.withValues(alpha: 0.2);

    return Card(
      elevation: 0,
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(ruta),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.light
                      ? color.withValues(
                          red: color.r,
                          green: color.g * 0.7, // Reducimos intensidad del verde
                          blue: color.b,
                        )
                      : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../data/modelos/resultado_viaje.dart';
import '../../../providers/vehiculo_provider.dart';
import '../../../providers/componente_provider.dart';
import '../../../providers/logica_viaje_provider.dart';

/// Interfaz rediseñada (Premium) para planificar viajes largos.
class ViajeScreen extends ConsumerStatefulWidget {
  const ViajeScreen({super.key});

  @override
  ConsumerState<ViajeScreen> createState() => _ViajeScreenState();
}

class _ViajeScreenState extends ConsumerState<ViajeScreen> {
  final _kmController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<ResultadoViaje>? _resultados;
  bool _mostrarSoloUrgentes = false;
  bool _simulando = false;
  int _kmSimulados = 0;

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
  void dispose() {
    _kmController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _analizarViaje() async {
    FocusScope.of(context).unfocus();
    
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.requiredField)),
      );
      return;
    }

    // Limpiamos la entrada de km para aceptar formatos con puntos o espacios
    final kmTexto = _kmController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final kmEstimados = int.tryParse(kmTexto) ?? 0;
    
    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;

    if (vehiculo == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectVehicleFirst)),
        );
      }
      return;
    }

    setState(() => _simulando = true);

    try {
      // Nos aseguramos de tener los componentes cargados
      var estadoCompos = ref.read(componenteProvider);
      
      // Forzamos una recarga si no hay componentes o están cargando
      if (estadoCompos.componentes.isEmpty || estadoCompos.cargando) {
        await ref.read(componenteProvider.notifier).cargarComponentes(vehiculo.matricula!);
        estadoCompos = ref.read(componenteProvider);
      }

      if (estadoCompos.componentes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noComponentsRegistered)),
          );
        }
        return;
      }

      final servicio = ref.read(logicaViajeProveedor);
      final calculo = servicio.analizarViaje(
        vehiculo,
        estadoCompos.componentes,
        kmEstimados,
      );

      if (mounted) {
        setState(() {
          _resultados = calculo;
          _kmSimulados = kmEstimados;
        });
        
        // Mensaje de confirmación detallado
        final criticos = calculo.where((r) => r.estado == EstadoRecomendacion.rojo).length;
        if (criticos > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Atención: $criticos piezas requieren cambio según el plan.'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _simulando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final estadoCompos = ref.watch(componenteProvider);
    final vehiculoActual = ref.watch(vehiculoProvider).vehiculoSeleccionado;

    final resultadosMostrados = _resultados?.where((r) {
      if (!_mostrarSoloUrgentes) return true;
      return r.estado != EstadoRecomendacion.verde;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.tripSimulator, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: vehiculoActual == null
          ? Center(child: Text(l10n.selectVehicleFirst))
          : Column(
              children: [
                _buildHeaderForm(theme, estadoCompos.cargando, l10n),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: (estadoCompos.cargando || _simulando)
                        ? Center(key: const ValueKey('cargando_sim'), child: CircularProgressIndicator())
                        : _construirContenidoResultados(resultadosMostrados, theme, l10n),
                  ),
                ),
              ],
            ),
    );
  }

  /// Construye la cabecera con el formulario de simulación
  Widget _buildHeaderForm(ThemeData theme, bool cargando, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: l10n.destinationOrTripName,
                prefixIcon: const Icon(Icons.map_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _kmController,
                    decoration: InputDecoration(
                      labelText: l10n.totalKms,
                      suffixText: 'km',
                      prefixIcon: const Icon(Icons.route_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val == null || int.tryParse(val) == null) ? l10n.requiredField : null,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: (cargando || _simulando) ? null : _analizarViaje,
                    icon: _simulando
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.play_arrow),
                    label: Text(l10n.simulate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _mostrarSoloUrgentes,
              title: Text(l10n.filterCriticalOnly, style: const TextStyle(fontSize: 13)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              onChanged: (val) => setState(() => _mostrarSoloUrgentes = val ?? false),
            ),
          ],
        ),
      ),
    );
  }

  /// Organiza la lista de resultados con la tarjeta de resumen
  Widget _construirContenidoResultados(List<ResultadoViaje>? listaFiltrada, ThemeData theme, AppLocalizations l10n) {
    if (_resultados == null) return _buildEmptyState(theme, l10n);

    final resultados = listaFiltrada ?? [];

    return ListView(
      key: const ValueKey('lista_resultados'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildResumenGeneral(_resultados!, theme, l10n),
        const SizedBox(height: 24),
        
        Text(
          'PIEZAS A REVISAR',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),

        if (resultados.isEmpty)
          _buildNoAlertsState(theme, l10n)
        else
          ...resultados.map((r) => _buildResultadoCard(r, theme, l10n)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildNoAlertsState(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
        children: [
          Icon(Icons.check_circle, size: 48, color: Colors.green.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(l10n.everythingInOrder, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    ),
  );
}

  /// Tarjeta de resumen de viaje
  Widget _buildResumenGeneral(List<ResultadoViaje> resultados, ThemeData theme, AppLocalizations l10n) {
    final fallos = resultados.where((r) => r.estado == EstadoRecomendacion.rojo).length;
    final avisos = resultados.where((r) => r.estado == EstadoRecomendacion.amarillo).length;
    
    final Color colorEstado = fallos > 0 ? Colors.red : (avisos > 0 ? Colors.orange : Colors.green);
    final String titulo = fallos > 0 ? l10n.highRiskTrip : (avisos > 0 ? l10n.requiresAttention : l10n.safeTrip);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorEstado.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorEstado.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(fallos > 0 ? Icons.error : (avisos > 0 ? Icons.warning : Icons.check_circle), color: colorEstado, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorEstado)),
                Text(
                  fallos > 0 
                      ? l10n.componentsWillExceed(fallos) 
                      : (avisos > 0 ? l10n.piecesNearMaintenance(avisos) : l10n.everythingInOrder),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tarjeta individual de resultado
  Widget _buildResultadoCard(ResultadoViaje r, ThemeData theme, AppLocalizations l10n) {
    final color = r.estado.colorVisual;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(r.estado.iconoVisual, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    r.componente.nombre,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (r.estado == EstadoRecomendacion.rojo)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                    child: Text(l10n.urgentStatus.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(r.mensajeRecomendacion, style: TextStyle(color: color, fontSize: 13)),
            const SizedBox(height: 16),
            _buildBarraDesgaste(r, theme),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.current}: ${r.kmRestantesActuales} km', style: theme.textTheme.labelSmall),
                Text('${l10n.afterTrip}: ${r.kmDespuesViaje} km', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Barra de desgaste
  Widget _buildBarraDesgaste(ResultadoViaje r, ThemeData theme) {
    final int vidaTotal = r.componente.intervaloKm;
    if (vidaTotal <= 0) return const SizedBox.shrink();

    final int kmUsadosAntes = (vidaTotal - r.kmRestantesActuales).clamp(0, vidaTotal);
    final double pctAntes = (kmUsadosAntes / vidaTotal).clamp(0.0, 1.0);
    final double pctViaje = (_kmSimulados / vidaTotal).clamp(0.0, 1.0 - pctAntes);
    final bool sepasa = (kmUsadosAntes + _kmSimulados) > vidaTotal;

    return Container(
      height: 10,
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: Colors.transparent,
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pctAntes,
              child: Container(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Row(
                children: [
                  SizedBox(width: (pctAntes * 100)), // Dummy spacer if needed but let's use stack properly
                ],
              ),
            ),
            // Correct positioning of trip impact
             LayoutBuilder(builder: (context, constraints) {
               return Stack(
                 children: [
                   Positioned(
                     left: constraints.maxWidth * pctAntes,
                     child: Container(
                       height: 10,
                       width: constraints.maxWidth * pctViaje,
                       color: sepasa ? Colors.red : r.estado.colorVisual,
                     ),
                   ),
                 ],
               );
             }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(l10n.planNextAdventure, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

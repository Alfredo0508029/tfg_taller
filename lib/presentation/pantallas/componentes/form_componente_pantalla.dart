import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../data/modelos/componente.dart';
import '../../../data/constantes/componentes_predefinidos.dart';
import '../../../providers/vehiculo_provider.dart';
import '../../../providers/componente_provider.dart';

/// Formulario para añadir o editar un componente.
/// Permite seleccionar componentes de una lista predefinida o crear personalizados.
class FormComponentePantalla extends ConsumerStatefulWidget {
  final Componente? componente;

  const FormComponentePantalla({super.key, this.componente});

  @override
  ConsumerState<FormComponentePantalla> createState() =>
      _FormComponentePantallaState();
}

class _FormComponentePantallaState
    extends ConsumerState<FormComponentePantalla> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _intervaloCtrl;
  late final TextEditingController _ultimoCambioCtrl;
  bool _expandido = false; // Controla si se muestran todas las sugerencias

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.componente?.nombre ?? '');
    _intervaloCtrl = TextEditingController(
      text: widget.componente?.intervaloKm.toString() ?? '',
    );
    _ultimoCambioCtrl = TextEditingController(
      text: widget.componente?.ultimoCambioKm.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _intervaloCtrl.dispose();
    _ultimoCambioCtrl.dispose();
    super.dispose();
  }

  /// Autocompleta los campos si el usuario selecciona una opción predefinida.
  void _alSeleccionarPredefinido(Map<String, dynamic> predefinido) {
    setState(() {
      _nombreCtrl.text = predefinido['nombre'] as String;
      _intervaloCtrl.text = (predefinido['intervaloKm'] as int).toString();

      // Si el último cambio está vacío, lo sugerimos igual al kilometraje actual del vehículo
      if (_ultimoCambioCtrl.text.isEmpty) {
        final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
        if (vehiculo != null) {
          _ultimoCambioCtrl.text = vehiculo.kilometrajeActual.toString();
        }
      }
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
    if (vehiculo == null) return;

    final nuevoComponente = Componente(
      id: widget.componente?.id,
      vehiculoMatricula: vehiculo.matricula!,
      nombre: _nombreCtrl.text.trim(),
      intervaloKm: int.parse(_intervaloCtrl.text.trim()),
      ultimoCambioKm: int.parse(_ultimoCambioCtrl.text.trim()),
    );

    bool exito;
    if (widget.componente == null) {
      exito = await ref
          .read(componenteProvider.notifier)
          .agregarComponente(nuevoComponente);
    } else {
      exito = await ref
          .read(componenteProvider.notifier)
          .actualizarComponente(nuevoComponente);
    }

    if (exito && mounted) {
      context.pop(); // Volver a la lista de componentes
    } else if (mounted) {
      final error = ref.read(componenteProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Error desconocido')));
    }
  }

  Future<void> _eliminar(AppLocalizations l10n) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteComponentConfirm),
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
      final vehiculoMatricula = ref.read(vehiculoProvider).vehiculoSeleccionado!.matricula!;
      final exito = await ref
          .read(componenteProvider.notifier)
          .eliminarComponente(widget.componente!.id!, vehiculoMatricula);

      if (exito && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final esEdicion = widget.componente != null;
    final sugerencias = ComponentesPredefinidos.obtenerSugerencias(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? l10n.editComponent : l10n.addComponent),
        actions: [
          if (esEdicion)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => _eliminar(l10n),
              tooltip: l10n.delete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sugerencias solo en modo creación
              if (!esEdicion) ...[
                Text(
                  l10n.quickSuggestions,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _expandido
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: sugerencias.map((sugerencia) {
                                return ActionChip(
                                  label: Text(sugerencia['nombre'] as String),
                                  onPressed: () =>
                                      _alSeleccionarPredefinido(sugerencia),
                                );
                              }).toList(),
                            )
                          : SizedBox(
                              height: 40,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: sugerencias.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final sugerencia = sugerencias[index];
                                  return ActionChip(
                                    label: Text(sugerencia['nombre'] as String),
                                    onPressed: () =>
                                        _alSeleccionarPredefinido(sugerencia),
                                  );
                                },
                              ),
                            ),
                    ),
                    IconButton(
                      icon: Icon(
                        _expandido ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => setState(() => _expandido = !_expandido),
                      tooltip: _expandido
                          ? l10n.showLess
                          : l10n.showAllSuggestions,
                    ),
                  ],
                ),
                
               
                const SizedBox(height: 24),
              ],

              // Nombre
              TextFormField(
                controller: _nombreCtrl,
                decoration: InputDecoration(
                  labelText: l10n.componentName,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.build),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    v == null || v.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),

              // Intervalo de reemplazo
              TextFormField(
                controller: _intervaloCtrl,
                decoration: InputDecoration(
                  labelText: l10n.replacementInterval,
                  suffixText: 'km',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.sync),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  if (int.tryParse(valor) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Km al último cambio
              TextFormField(
                controller: _ultimoCambioCtrl,
                decoration: InputDecoration(
                  labelText: l10n.lastChangeMileage,
                  suffixText: 'km',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.history),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  if (int.tryParse(valor) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(l10n.save, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

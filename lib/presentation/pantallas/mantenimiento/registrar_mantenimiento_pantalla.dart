// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../data/modelos/componente.dart';
import '../../../data/modelos/registro_mantenimiento.dart';
import '../../../providers/vehiculo_provider.dart';
import '../../../providers/componente_provider.dart';
import '../../../providers/mantenimiento_provider.dart';
// import '../../../providers/storage_provider.dart';
import '../../../providers/notificaciones_provider.dart';

/// Formulario para registrar que se ha realizado un mantenimiento.
/// Permite seleccionar el componente, la fecha, el kilometraje, notas
/// y adjuntar una fotografía del trabajo realizado.
class RegistrarMantenimientoPantalla extends ConsumerStatefulWidget {
  const RegistrarMantenimientoPantalla({super.key});

  @override
  ConsumerState<RegistrarMantenimientoPantalla> createState() =>
      _RegistrarMantenimientoPantallaState();
}

class _RegistrarMantenimientoPantallaState
    extends ConsumerState<RegistrarMantenimientoPantalla> {
  final _formKey = GlobalKey<FormState>();

  /// Componente de mantenimiento seleccionado en el desplegable.
  Componente? _componenteSeleccionado;

  /// Fecha elegida para el registro de mantenimiento.
  DateTime _fechaSeleccionada = DateTime.now();

  late final TextEditingController _kmCtrl;
  late final TextEditingController _notasCtrl;
  late final TextEditingController _precioCtrl;

  // /// Imagen del mantenimiento seleccionada localmente (aún no subida).
  // File? _imagenSeleccionada;

  /// Indica si se está procesando el guardado (imagen + registro).
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
    final kmBase = vehiculo?.kilometrajeActual.toString() ?? '';
    _kmCtrl = TextEditingController(text: kmBase);
    _notasCtrl = TextEditingController();
    _precioCtrl = TextEditingController();

    // Cargamos los componentes del vehículo seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vehiculo != null) {
        ref
            .read(componenteProvider.notifier)
            .cargarComponentes(vehiculo.matricula!);
      }
    });
  }

  @override
  void dispose() {
    _kmCtrl.dispose();
    _notasCtrl.dispose();
    _precioCtrl.dispose();
    super.dispose();
  }

  /// Abre el selector de fecha del sistema.
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (seleccion != null && seleccion != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = seleccion;
      });
    }
  }

  // /// Abre la galería para que el usuario elija una foto del mantenimiento.
  // Future<void> _seleccionarImagen() async {
  //   final picker = ImagePicker();
  //   final XFile? archivo = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 85,
  //   );
  //   if (archivo != null) {
  //     setState(() {
  //       _imagenSeleccionada = File(archivo.path);
  //     });
  //   }
  // }

  /// Valida, sube la imagen si procede, guarda el registro y actualiza el componente.
  Future<void> _guardar() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_componenteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectComponent)),
      );
      return;
    }

    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
    if (vehiculo == null) return;

    setState(() => _guardando = true);

    final kmRegistro = int.parse(_kmCtrl.text.trim());

    // ── 1. Subir imagen si el usuario seleccionó una (comentado, no se usa) ────
    String? urlImagen;
    // if (_imagenSeleccionada != null) {
    //   final storageServicio = ref.read(storageServicioProvider);
    //   final usuarioId = Supabase.instance.client.auth.currentUser?.id;
    //   // Usamos un timestamp para garantizar nombre único en cada registro
    //   final nombreArchivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    //   urlImagen = await storageServicio.subirImagen(
    //     archivo: _imagenSeleccionada!,
    //     bucket: 'mantenimientos',
    //     // Ruta: mantenimientos/{usuario_id}/{timestamp}.jpg
    //     rutaEnBucket: '$usuarioId/$nombreArchivo',
    //   );
    // }

    // ── 2. Crear el registro de mantenimiento ────────────────────────────────
    final registro = RegistroMantenimiento(
      componenteId: _componenteSeleccionado!.id!,
      vehiculoMatricula: vehiculo.matricula!,
      nombreComponente: _componenteSeleccionado!.nombre,
      fecha: _fechaSeleccionada,
      kilometraje: kmRegistro,
      notas: _notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim(),
      imagenUrl: urlImagen,
      precio: _precioCtrl.text.trim().isEmpty ? null : double.tryParse(_precioCtrl.text.trim().replaceAll(',', '.')),
    );

    // ── 3. Guardar el registro en Supabase ────────────────────────────────────
    final exitoRegistro = await ref
        .read(mantenimientoProvider.notifier)
        .registrarMantenimiento(registro);

    if (exitoRegistro) {
      // ── 4. Actualizar el km del último cambio del componente ──────────────
      await ref
          .read(componenteProvider.notifier)
          .registrarCambio(
            _componenteSeleccionado!.id!,
            kmRegistro,
            vehiculo.matricula!,
          );

      // ── 5. Si el km del registro supera el del vehículo, actualizarlo ─────
      if (kmRegistro > vehiculo.kilometrajeActual) {
        await ref
            .read(vehiculoProvider.notifier)
            .actualizarKilometraje(vehiculo.matricula!, kmRegistro);
      }

      // ── 6. Verificar notificaciones con los datos actualizados ─────────────
      // Cargamos los componentes actualizados y comprobamos alertas
      final componentesActualizados =
          ref.read(componenteProvider).componentes;
      await ref
          .read(notificacionesServicioProvider)
          .verificarComponentes(componentesActualizados, kmRegistro, vehiculo.matricula!);

      if (mounted) context.pop();
    }

    if (mounted) setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    final estadoComponentes = ref.watch(componenteProvider);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    );
    // final theme = Theme.of(context); // (comentado: se usaba para el selector de imagen)

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerMaintenance)),
      body: estadoComponentes.cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Selector de Componente ─────────────────────────────
                    DropdownButtonFormField<Componente>(
                      decoration: InputDecoration(
                        labelText: l10n.componentName,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.build),
                      ),
                      initialValue: _componenteSeleccionado,
                      items: estadoComponentes.componentes.isEmpty
                          ? [
                              DropdownMenuItem(
                                value: null,
                                child: Text(l10n.noComponentsRegistered),
                              ),
                            ]
                          : estadoComponentes.componentes
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.nombre),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() => _componenteSeleccionado = val);
                      },
                      validator: (val) =>
                          val == null ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: 16),

                    // ── Selector de Fecha ──────────────────────────────────
                    InkWell(
                      onTap: () => _seleccionarFecha(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.maintenanceDate,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(dateFormat.format(_fechaSeleccionada)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Kilometraje en el momento del cambio ───────────────
                    TextFormField(
                      controller: _kmCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.kmAtChange,
                        suffixText: 'km',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.speed, semanticLabel: 'Icono de kilometraje'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return l10n.requiredField;
                        }
                        if (int.tryParse(valor) == null) {
                          return l10n.invalidNumber;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Coste / Precio (Opcional) ──────────────────────────
                    TextFormField(
                      controller: _precioCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.maintenanceCostOptional,
                        suffixText: '€',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.euro, semanticLabel: 'Icono de moneda'),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (valor) {
                        if (valor != null && valor.isNotEmpty) {
                          if (double.tryParse(valor.replaceAll(',', '.')) == null) {
                            return l10n.invalidNumber;
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Notas opcionales ───────────────────────────────────
                    TextFormField(
                      controller: _notasCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.notes, semanticLabel: 'Icono de notas'),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),

                    // ── Selector de imagen del mantenimiento (comentado, no se usa) ─
                    // _buildSelectorImagen(theme),
                    // const SizedBox(height: 32),

                    // ── Botón Guardar ──────────────────────────────────────
                    FilledButton.icon(
                      onPressed: _guardando ? null : _guardar,
                      icon: _guardando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_task),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          l10n.save,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // /// Construye el área de selección de imagen del mantenimiento.
  // Widget _buildSelectorImagen(ThemeData theme) {
  //   return InkWell(
  //     onTap: _seleccionarImagen,
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       height: 140,
  //       decoration: BoxDecoration(
  //         color: theme.colorScheme.surfaceContainerHighest,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: theme.colorScheme.outline.withValues(alpha: 0.4),
  //         ),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(12),
  //         child: _imagenSeleccionada != null
  //             // Previsualización de la foto elegida
  //             ? Stack(
  //                 fit: StackFit.expand,
  //                 children: [
  //                   Image.file(_imagenSeleccionada!, fit: BoxFit.cover),
  //                   // Botón de cambio superpuesto
  //                   Positioned(
  //                     right: 8,
  //                     bottom: 8,
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 10, vertical: 6),
  //                       decoration: BoxDecoration(
  //                         color: Colors.black54,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: const Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(Icons.edit, size: 14, color: Colors.white),
  //                           SizedBox(width: 4),
  //                           Text('Cambiar',
  //                               style: TextStyle(
  //                                   color: Colors.white, fontSize: 12)),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             // Placeholder sin imagen
  //             : Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.add_a_photo_outlined,
  //                     size: 36,
  //                     color: theme.colorScheme.onSurfaceVariant,
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     'Añadir foto del mantenimiento (opcional)',
  //                     style: theme.textTheme.bodySmall?.copyWith(
  //                       color: theme.colorScheme.onSurfaceVariant,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //       ),
  //     ),
  //   );
  // }
}

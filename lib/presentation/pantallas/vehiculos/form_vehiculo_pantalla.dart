// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../data/modelos/vehiculo.dart';
import '../../../providers/vehiculo_provider.dart';
// import '../../../providers/storage_provider.dart';

/// Formulario para crear o editar un vehículo.
/// Permite adjuntar una fotografía desde la galería del dispositivo,
/// que se subirá a Supabase Storage antes de guardar el vehículo.
class FormVehiculoPantalla extends ConsumerStatefulWidget {
  /// Si es null, modo creación. Si tiene valor, modo edición.
  final Vehiculo? vehiculo;

  const FormVehiculoPantalla({super.key, this.vehiculo});

  @override
  ConsumerState<FormVehiculoPantalla> createState() =>
      _FormVehiculoPantallaState();
}

class _FormVehiculoPantallaState extends ConsumerState<FormVehiculoPantalla> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _matriculaCtrl;
  late final TextEditingController _marcaCtrl;
  late final TextEditingController _modeloCtrl;
  late final TextEditingController _anioCtrl;
  late final TextEditingController _kmCtrl;
  String _tipoCarburanteSeleccionado = 'gasolina';

  // /// Archivo de imagen seleccionado localmente por el usuario (aún no subido).
  // File? _imagenSeleccionada;

  // /// URL de la imagen ya almacenada en Supabase (si se está editando un vehículo).
  // String? _imagenUrlExistente;

  /// Si está en proceso de subir la imagen o guardar el formulario.
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _matriculaCtrl = TextEditingController(
      text: widget.vehiculo?.matricula ?? '',
    );
    _marcaCtrl = TextEditingController(text: widget.vehiculo?.marca ?? '');
    _modeloCtrl = TextEditingController(text: widget.vehiculo?.modelo ?? '');
    _anioCtrl = TextEditingController(
      text: widget.vehiculo?.anio.toString() ?? '',
    );
    _kmCtrl = TextEditingController(
      text: widget.vehiculo?.kilometrajeActual.toString() ?? '',
    );
    _tipoCarburanteSeleccionado = widget.vehiculo?.tipoCarburante ?? 'gasolina';
    // Guardamos la URL de la imagen existente del vehículo (si está en modo edición)
    // _imagenUrlExistente = widget.vehiculo?.imagenUrl;
  }

  @override
  void dispose() {
    _matriculaCtrl.dispose();
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _anioCtrl.dispose();
    _kmCtrl.dispose();
    super.dispose();
  }

  // /// Abre la galería del dispositivo para que el usuario seleccione una imagen.
  // Future<void> _seleccionarImagen() async {
  //   final picker = ImagePicker();
  //   // Limitamos la calidad al 85 % para reducir el tamaño del archivo
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

  /// Valida el formulario, sube la imagen si procede y guarda el vehículo.
  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    // Determinamos la URL final de la imagen:
    // String? urlImagen = _imagenUrlExistente;
    String? urlImagen;

    // if (_imagenSeleccionada != null) {
    //   // Hay una imagen nueva seleccionada → la subimos a Supabase Storage
    //   final storageServicio = ref.read(storageServicioProvider);
    //   final usuarioId = Supabase.instance.client.auth.currentUser?.id;
    //   // Extraemos una versión segura de la matrícula para no romper la URL HTTP (como el uso de '#')
    //   final safeFilename = _matriculaCtrl.text
    //       .trim()
    //       .toUpperCase()
    //       .replaceAll(RegExp(r'[^A-Z0-9]'), '_');

    //   urlImagen = await storageServicio.subirImagen(
    //     archivo: _imagenSeleccionada!,
    //     bucket: 'vehiculos',
    //     // Ruta: vehiculos/{usuario_id}/{matricula_limpia}.jpg
    //     rutaEnBucket: '$usuarioId/$safeFilename.jpg',
    //   );

    //   if (urlImagen == null) {
    //     if (!mounted) return;
    //     setState(() => _guardando = false);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'Supabase rechazó la subida. Verifica que el Bucket existe, que es público y que cuenta con permisos RLS.',
    //         ),
    //         duration: Duration(seconds: 4),
    //       ),
    //     );
    //     return; // Interrumpimos el guardado en lugar de guardar en blanco
    //   }
    // }

    // Construimos el objeto vehículo con todos sus datos
    final nuevoVehiculo = Vehiculo(
      matricula: _matriculaCtrl.text.trim().toUpperCase(),
      marca: _marcaCtrl.text.trim(),
      modelo: _modeloCtrl.text.trim(),
      anio: int.parse(_anioCtrl.text.trim()),
      kilometrajeActual: int.parse(_kmCtrl.text.trim()),
      tipoCarburante: _tipoCarburanteSeleccionado,
      imagenUrl: urlImagen,
    );

    bool exito;
    if (widget.vehiculo == null) {
      // Modo creación: insertamos el vehículo nuevo
      exito = await ref
          .read(vehiculoProvider.notifier)
          .agregarVehiculo(nuevoVehiculo);
    } else {
      // Modo edición: actualizamos el vehículo existente
      exito = await ref
          .read(vehiculoProvider.notifier)
          .actualizarVehiculo(nuevoVehiculo);
    }

    if (!mounted) return;
    setState(() => _guardando = false);

    if (exito) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    } else {
      // Mostramos el error que se encuentra en el estado del provider
      final error = ref.read(vehiculoProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Error desconocido')));
    }
  }

  /// Muestra un diálogo de confirmación antes de eliminar el vehículo.
  Future<void> _eliminar(AppLocalizations l10n) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteVehicleConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final exito = await ref
          .read(vehiculoProvider.notifier)
          .eliminarVehiculo(widget.vehiculo!.matricula!);

      if (exito && mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.vehiculo != null;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? l10n.editVehicle : l10n.addVehicle),
        actions: [
          if (esEdicion)
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
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
              // ── Selector de imagen (no se usa) ───────────────
              // _SelectorImagen(
              //   imagenSeleccionada: _imagenSeleccionada,
              //   imagenUrlExistente: _imagenUrlExistente,
              //   onSeleccionar: _seleccionarImagen,
              // ),
              // const SizedBox(height: 16),

              // ── Matrícula ───────────────────────────────────────────────
              TextFormField(
                controller: _matriculaCtrl,
                decoration: InputDecoration(
                  labelText: l10n.licensePlate,
                  hintText: l10n.licensePlateHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.numbers, semanticLabel: 'Icono de matrícula'),
                ),
                textCapitalization: TextCapitalization.characters,
                // En modo edición no se puede cambiar la matrícula (es la PK)
                readOnly: esEdicion,
                validator: (valor) =>
                    valor == null || valor.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),

              // ── Marca ────────────────────────────────────────────────────
              TextFormField(
                controller: _marcaCtrl,
                decoration: InputDecoration(
                  labelText: l10n.brand,
                  hintText: l10n.brandHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.branding_watermark, semanticLabel: 'Icono de marca'),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (valor) =>
                    valor == null || valor.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),

              // ── Modelo ───────────────────────────────────────────────────
              TextFormField(
                controller: _modeloCtrl,
                decoration: InputDecoration(
                  labelText: l10n.model,
                  hintText: l10n.modelHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.directions_car, semanticLabel: 'Icono de coche'),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (valor) =>
                    valor == null || valor.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),

              // ── Año ──────────────────────────────────────────────────────
              TextFormField(
                controller: _anioCtrl,
                decoration: InputDecoration(
                  labelText: l10n.year,
                  hintText: l10n.yearHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today, semanticLabel: 'Icono de calendario'),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  final num = int.tryParse(valor);
                  if (num == null || num < 1900 || num > 2100) {
                    return l10n.invalidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Kilometraje ──────────────────────────────────────────────
              TextFormField(
                controller: _kmCtrl,
                decoration: InputDecoration(
                  labelText: l10n.currentMileage,
                  hintText: '0',
                  suffixText: 'km',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.speed, semanticLabel: 'Icono de kilometraje'),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  if (int.tryParse(valor) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Tipo Carburante ──────────────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _tipoCarburanteSeleccionado,
                decoration: InputDecoration(
                  labelText: l10n.fuelType,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.local_gas_station, semanticLabel: 'Icono de combustible'),
                ),
                items: [
                  DropdownMenuItem(value: 'gasolina', child: Text(l10n.fuel_gasoline)),
                  DropdownMenuItem(value: 'diésel', child: Text(l10n.fuel_diesel)),
                  DropdownMenuItem(value: 'eléctrico', child: Text(l10n.fuel_electric)),
                  DropdownMenuItem(value: 'híbrido', child: Text(l10n.fuel_hybrid)),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _tipoCarburanteSeleccionado = val);
                  }
                },
              ),
              const SizedBox(height: 32),

              // ── Botón Guardar ────────────────────────────────────────────
              FilledButton.icon(
                // Bloqueamos el botón mientras se guarda para evitar envíos dobles
                onPressed: _guardando ? null : _guardar,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
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

// /// Widget auxiliar que muestra la imagen actual del vehículo (si existe)
// /// o un área de placeholder con icono de cámara para que el usuario la seleccione.
// class _SelectorImagen extends StatelessWidget {
//   final File? imagenSeleccionada;
//   final String? imagenUrlExistente;
//   final VoidCallback onSeleccionar;

//   const _SelectorImagen({
//     required this.imagenSeleccionada,
//     required this.imagenUrlExistente,
//     required this.onSeleccionar,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return InkWell(
//       onTap: onSeleccionar,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         height: 180,
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surfaceContainerHighest,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: theme.colorScheme.outline.withValues(alpha: 0.4),
//           ),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: _contenidoImagen(theme),
//         ),
//       ),
//     );
//   }

//   /// Decide qué imagen mostrar según el estado actual:
//   /// 1. Imagen recién seleccionada de la galería (archivo local).
//   /// 2. Imagen previamente guardada en Storage (URL de red).
//   /// 3. Placeholder si no hay imagen.
//   Widget _contenidoImagen(ThemeData theme) {
//     if (imagenSeleccionada != null) {
//       // Mostramos la imagen local recién elegida
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.file(imagenSeleccionada!, fit: BoxFit.cover),
//           _botonCambiar(theme),
//         ],
//       );
//     }

//     if (imagenUrlExistente != null && imagenUrlExistente!.isNotEmpty) {
//       // Mostramos la imagen que ya estaba guardada en Supabase Storage
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.network(
//             imagenUrlExistente!,
//             fit: BoxFit.cover,
//             // Widget mientras carga la imagen de red
//             loadingBuilder: (_, child, progress) => progress == null
//                 ? child
//                 : const Center(child: CircularProgressIndicator()),
//             // Widget si falla la carga
//             errorBuilder: (_, __, ___) => _placeholder(theme),
//           ),
//           _botonCambiar(theme),
//         ],
//       );
//     }

//     // Sin imagen: mostramos el área de selección con icono
//     return _placeholder(theme);
//   }

//   /// Área vacía con icono de cámara que invita al usuario a seleccionar foto.
//   Widget _placeholder(ThemeData theme) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.add_a_photo_outlined,
//           size: 48,
//           color: theme.colorScheme.onSurfaceVariant,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Toca para añadir foto',
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: theme.colorScheme.onSurfaceVariant,
//           ),
//         ),
//       ],
//     );
//   }

//   /// Botón semitransparente superpuesto a la imagen para cambiarla.
//   Widget _botonCambiar(ThemeData theme) {
//     return Positioned(
//       right: 8,
//       bottom: 8,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.black54,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.edit, size: 14, color: Colors.white),
//             SizedBox(width: 4),
//             Text('Cambiar',
//                 style: TextStyle(color: Colors.white, fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
// }

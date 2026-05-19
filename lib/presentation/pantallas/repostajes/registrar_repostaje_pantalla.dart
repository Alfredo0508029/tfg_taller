import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../data/modelos/repostaje.dart';
import '../../../providers/vehiculo_provider.dart';
import '../../../providers/repostaje_provider.dart';

class RegistrarRepostajePantalla extends ConsumerStatefulWidget {
  const RegistrarRepostajePantalla({super.key});

  @override
  ConsumerState<RegistrarRepostajePantalla> createState() =>
      _RegistrarRepostajePantallaState();
}

class _RegistrarRepostajePantallaState extends ConsumerState<RegistrarRepostajePantalla> {
  final _formKey = GlobalKey<FormState>();

  DateTime _fechaSeleccionada = DateTime.now();

  late final TextEditingController _kmCtrl;
  late final TextEditingController _litrosCtrl;
  late final TextEditingController _precioTotalCtrl;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
    // Pre-llenar el km actual para comodidad, típicamente has subido de km
    final kmBase = vehiculo?.kilometrajeActual.toString() ?? '';
    _kmCtrl = TextEditingController(text: kmBase);
    _litrosCtrl = TextEditingController();
    _precioTotalCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _kmCtrl.dispose();
    _litrosCtrl.dispose();
    _precioTotalCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (seleccion != null && seleccion != _fechaSeleccionada) {
      setState(() => _fechaSeleccionada = seleccion);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final vehiculo = ref.read(vehiculoProvider).vehiculoSeleccionado;
    if (vehiculo == null) return;

    setState(() => _guardando = true);

    final kmRegistro = int.parse(_kmCtrl.text.trim());
    final litrosReg = double.parse(_litrosCtrl.text.trim().replaceAll(',', '.'));
    final precioReg = double.parse(_precioTotalCtrl.text.trim().replaceAll(',', '.'));
    final precioUnidad = precioReg / litrosReg;

    final nuevoRepostaje = Repostaje(
      vehiculoMatricula: vehiculo.matricula!,
      fecha: _fechaSeleccionada,
      kilometraje: kmRegistro,
      litros: litrosReg,
      precioTotal: precioReg,
      precioPorLitro: precioUnidad,
    );

    final exito = await ref.read(repostajeProvider.notifier).registrarRepostaje(nuevoRepostaje);

    if (exito) {
      if (kmRegistro > vehiculo.kilometrajeActual) {
         await ref.read(vehiculoProvider.notifier).actualizarKilometraje(vehiculo.matricula!, kmRegistro);
      }
      if (mounted) context.pop();
    } else {
      if (mounted) {
         final error = ref.read(repostajeProvider).error;
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error ?? 'Error al guardar')));
      }
    }

    if (mounted) setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    final vehiculo = ref.watch(vehiculoProvider).vehiculoSeleccionado;
    final esElectrico = vehiculo?.tipoCarburante.toLowerCase() == 'eléctrico' || vehiculo?.tipoCarburante.toLowerCase() == 'electric';
    final nombreLitro = esElectrico ? l10n.kWhCharged : l10n.litersRefueled;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerRefuel)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Selector de Fecha ──────────────────────────────────
              InkWell(
                onTap: () => _seleccionarFecha(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.refuelDate,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(dateFormat.format(_fechaSeleccionada)),
                ),
              ),
              const SizedBox(height: 16),

              // ── Kilometraje ───────────────
              TextFormField(
                controller: _kmCtrl,
                decoration: InputDecoration(
                  labelText: l10n.mileageAtPump,
                  suffixText: 'km',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  if (int.tryParse(valor) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Litros / kWh ───────────────────────────────────
              TextFormField(
                controller: _litrosCtrl,
                decoration: InputDecoration(
                  labelText: nombreLitro,
                  suffixText: esElectrico ? 'kWh' : 'L',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(esElectrico ? Icons.electric_bolt : Icons.water_drop),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  if (double.tryParse(valor.replaceAll(',', '.')) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Precio Total ───────────────────────────────────
              TextFormField(
                controller: _precioTotalCtrl,
                decoration: InputDecoration(
                  labelText: l10n.totalAmountToPay,
                  suffixText: '€',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.payment),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return l10n.requiredField;
                  if (double.tryParse(valor.replaceAll(',', '.')) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // ── Botón Guardar ──────────────────────────────────────
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.local_gas_station),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(l10n.registerExpense, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

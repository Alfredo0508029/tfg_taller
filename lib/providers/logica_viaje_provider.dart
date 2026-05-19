import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../servicios/logica_viaje_servicio.dart';

/// Provider que inyecta la dependencia del buscador de viajes de forma global,
/// evitando instanciar el servicio en cada widget.
final logicaViajeProveedor = Provider<LogicaViajeServicio>((ref) {
  return LogicaViajeServicio();
});

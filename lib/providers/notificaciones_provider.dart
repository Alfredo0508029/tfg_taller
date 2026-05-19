import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../servicios/notificaciones_servicio.dart';

/// Provider global que expone el [NotificacionesServicio] a toda la aplicación.
/// Al ser un [Provider] simple (sin estado reactivo), devuelve siempre la
/// misma instancia del servicio durante toda la vida de la app.
final notificacionesServicioProvider = Provider<NotificacionesServicio>((ref) {
  return NotificacionesServicio();
});

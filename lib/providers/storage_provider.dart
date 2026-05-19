import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../servicios/storage_servicio.dart';

/// Provider global que expone el [StorageServicio] a toda la aplicación.
/// Al ser un [Provider] simple, devuelve siempre la misma instancia.
final storageServicioProvider = Provider<StorageServicio>((ref) {
  return StorageServicio();
});

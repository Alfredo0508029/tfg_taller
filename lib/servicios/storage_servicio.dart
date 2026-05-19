import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio responsable de gestionar la subida y descarga de imágenes en
/// Supabase Storage. Encapsula toda la lógica de Storage para que el resto
/// de la aplicación no sepa los detalles de implementación de la API.
class StorageServicio {
  /// Referencia al cliente oficial de Supabase.
  SupabaseClient get _cliente => Supabase.instance.client;

  /// Sube un archivo de imagen al bucket indicado de Supabase Storage y
  /// devuelve la URL pública para acceder a ella desde cualquier navegador.
  ///
  /// Parámetros:
  /// - [archivo]: El fichero local a subir (seleccionado con image_picker).
  /// - [bucket]: El bucket de destino ('vehiculos' o 'mantenimientos').
  /// - [rutaEnBucket]: La ruta relativa dentro del bucket, por ejemplo
  ///   '{usuario_id}/{matricula}.jpg'.
  ///
  /// Devuelve la URL pública de la imagen o `null` si se produjo algún error.
  Future<String?> subirImagen({
    required File archivo,
    required String bucket,
    required String rutaEnBucket,
  }) async {
    try {
      // Convertimos el fichero a bytes puros para evitar fallos locales en Android
      final bytes = await archivo.readAsBytes();

      // Subimos los bytes directamente; si ya existía uno con el mismo nombre, lo reemplazamos
      await _cliente.storage.from(bucket).uploadBinary(
            rutaEnBucket,
            bytes,
            fileOptions: const FileOptions(
              // Reemplazar imagen si ya existía (útil al editar un vehículo)
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Obtenemos la URL pública permanente para almacenarla en la base de datos
      final urlPublica =
          _cliente.storage.from(bucket).getPublicUrl(rutaEnBucket);
      return urlPublica;
    } catch (e) {
      // Cualquier error de red o de Supabase lo capturamos sin romper la app
      // ignore: avoid_print
      print('[StorageServicio] Error al subir imagen: $e');
      return null;
    }
  }

  /// Elimina una imagen del Storage a partir de su ruta en el bucket.
  ///
  /// Se usa cuando el usuario elimina un vehículo o un registro de mantenimiento
  /// para no dejar archivos huérfanos en el Storage.
  Future<void> eliminarImagen({
    required String bucket,
    required String rutaEnBucket,
  }) async {
    try {
      await _cliente.storage.from(bucket).remove([rutaEnBucket]);
    } catch (e) {
      // Si falla el borrado (p. ej. el archivo no existe), lo ignoramos
      // ignore: avoid_print
      print('[StorageServicio] Error al eliminar imagen: $e');
    }
  }

  /// Extrae el ID del usuario autenticado actualmente.
  /// Devuelve `null` si no hay sesión activa.
  String? get usuarioId => _cliente.auth.currentUser?.id;
}

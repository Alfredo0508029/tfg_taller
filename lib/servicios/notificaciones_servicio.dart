import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/modelos/componente.dart';
import 'salud_vehiculo_servicio.dart';

/// Servicio centralizado para gestionar notificaciones locales inteligentes.
/// Implementa lógica de 'debounce' (evitar repeticiones) usando caché local.
/// Se utiliza como Singleton para garantizar que la instancia inicializada en
/// main.dart sea la misma que consume el provider de Riverpod.
class NotificacionesServicio {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final NotificacionesServicio _instance = NotificacionesServicio._internal();
  factory NotificacionesServicio() => _instance;
  NotificacionesServicio._internal();
  // ──────────────────────────────────────────────────────────────────────────

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inicializado = false;

  /// Verifica si la plataforma actual está soportada por el plugin core.
  bool get _esPlataformaSoportada {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isLinux;
  }

  static const int _idRecordatorioKm = 0;
  static const int _idBaseComponentes = 100;
  static const int _umbralKmPrevio = 2000; // Amarillo según requerimientos

  Future<void> inicializar() async {
    if (!_esPlataformaSoportada) {
      debugPrint('Notificaciones: Plataforma no soportada. Servicio deshabilitado.');
      return;
    }

    try {
      tz.initializeTimeZones();

      const ajustesAndroid = AndroidInitializationSettings('ic_notificacion');
      const ajustesIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const ajustesInit = InitializationSettings(
        android: ajustesAndroid,
        iOS: ajustesIOS,
      );

      await _plugin.initialize(ajustesInit);

      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      
      _inicializado = true;
    } catch (e) {
      debugPrint('Error al inicializar notificaciones: $e');
    }
  }

  /// Verifica si ha pasado suficiente tiempo para volver a enviar la misma notificación
  Future<bool> _deboNotificar(String clave, Duration intervalo) async {
    final prefs = await SharedPreferences.getInstance();
    final ultimaVezStr = prefs.getString(clave);
    final ahora = DateTime.now();

    if (ultimaVezStr != null) {
      final ultimaVez = DateTime.parse(ultimaVezStr);
      if (ahora.difference(ultimaVez) < intervalo) {
        return false; // Aún no ha superado el tiempo de "silencio"
      }
    }

    await prefs.setString(clave, ahora.toIso8601String());
    return true;
  }

  /// Elimina el registro de una notificación para permitir que vuelva a saltar inmediatamente
  Future<void> _resetNotificacion(String clave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(clave);
  }

  /// Elimina TODO el caché de debounce de notificaciones.
  /// Únicamente para pruebas o cuando el usuario quiere recibir todos los avisos de nuevo.
  Future<void> resetearCacheNotificaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final claves = prefs.getKeys().where((k) => k.startsWith('notif_')).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
    debugPrint('Notificaciones: Caché de debounce limpiado (${claves.length} entradas).');
  }

  /// Programación dinámica de 14 días para recordar inactividad
  Future<void> programarRecordatorioKilometraje() async {
    if (!_inicializado) return;
    
    await _plugin.cancel(_idRecordatorioKm);

    final fechaObjetivo = tz.TZDateTime.now(tz.local).add(
      const Duration(days: 14),
    );

    await _plugin.zonedSchedule(
      _idRecordatorioKm,
      '🚗 Inactividad detectada',
      'Hace tiempo que no actualizas los kilómetros de tu vehículo.',
      fechaObjetivo,
      _detallesNotificacion(
        idCanal: 'canal_recordatorio',
        nombreCanal: 'Recordatorio de kilometraje',
        descripcionCanal: 'Avisos por inactividad de uso',
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Evalúa los componentes y lanza notificaciones inteligentes
  Future<void> verificarComponentes(
    List<Componente> componentes,
    int kilometrajeActual,
    String matriculaVehiculo,
  ) async {
    debugPrint('Notificaciones: verificarComponentes -> inicializado=$_inicializado, nComponentes=${componentes.length}');
    if (!_inicializado) {
      debugPrint('Notificaciones: ABORTADO - servicio no inicializado.');
      return;
    }

    for (int i = 0; i < componentes.length; i++) {
      final componente = componentes[i];
      final kmRestantes = componente.kmRestantes(kilometrajeActual);
      final idNotificacion = _idBaseComponentes + i;
      
      // Creamos una clave única para este componente en caché
      final baseKey = 'notif_${matriculaVehiculo}_comp_${componente.id ?? componente.nombre}';

      if (kmRestantes <= 0) {
        debugPrint('Notificaciones: [ROJO] ${componente.nombre} - kmRestantes=$kmRestantes');
        // Rojo - Cada 3 días insiste
        if (await _deboNotificar('${baseKey}_rojo', const Duration(days: 3))) {
          debugPrint('Notificaciones: Mostrando notificación URGENTE para ${componente.nombre}');
          await _mostrarNotificacion(
            id: idNotificacion,
            titulo: '🔴 Mantenimiento urgente',
            cuerpo: 'El componente ${componente.nombre} necesita cambio urgente.',
            idCanal: 'canal_urgente',
            nombreCanal: 'Mantenimiento urgente',
            descripcionCanal: 'Avisos críticos de piezas caducadas',
            prioridad: Priority.max,
            importancia: Importance.max,
          );
        } else {
          debugPrint('Notificaciones: [ROJO] ${componente.nombre} - SILENCIADA por debounce.');
        }
        // Limpiamos el de amarillo por si acaso
        await _resetNotificacion('${baseKey}_amarillo');
      } else if (kmRestantes <= _umbralKmPrevio) {
        // Amarillo - Cada 7 días avisa
        if (await _deboNotificar('${baseKey}_amarillo', const Duration(days: 7))) {
          await _mostrarNotificacion(
            id: idNotificacion,
            titulo: '🟡 Mantenimiento próximo',
            cuerpo: 'El componente ${componente.nombre} está próximo a cambiarse.',
            idCanal: 'canal_aviso',
            nombreCanal: 'Aviso de mantenimiento',
            descripcionCanal: 'Prevención de desgaste',
            prioridad: Priority.defaultPriority,
            importancia: Importance.defaultImportance,
          );
        }
        // Limpiamos el de rojo ya que ya no es crítico
        await _resetNotificacion('${baseKey}_rojo');
      } else {
        // Estado Bueno (Verde) - Resetear ambos para permitir avisos inmediatos si vuelve a fallar
        await _resetNotificacion('${baseKey}_rojo');
        await _resetNotificacion('${baseKey}_amarillo');
      }
    }
  }

  /// Evalúa la salud general del coche
  Future<void> verificarSaludVehiculo(ReporteSalud reporte, String matriculaVehiculo) async {
    debugPrint('Notificaciones: verificarSaludVehiculo -> estado=${reporte.estado}, porcentaje=${reporte.porcentaje}');
    if (!_inicializado) {
      debugPrint('Notificaciones: ABORTADO salud - servicio no inicializado.');
      return;
    }

    final clave = 'notif_salud_baja_$matriculaVehiculo';
    if (reporte.estado == EstadoSaludVehiculo.critico) {
      // Estado Crítico de salud global - Avisar cada 5 días
      final debo = await _deboNotificar(clave, const Duration(days: 5));
      if (debo) {
        await _mostrarNotificacion(
          id: 9999, // Fijo genérico para salud
          titulo: '⚠️ Reparación necesaria',
          cuerpo: 'El estado general de tu vehículo requiere atención (${reporte.porcentaje.toStringAsFixed(0)}% de salud).',
          idCanal: 'canal_salud',
          nombreCanal: 'Salud del Vehículo',
          descripcionCanal: 'Avisos por estado de salud global suspensa',
          prioridad: Priority.max,
          importancia: Importance.max,
        );
      }
    } else {
      // Salud recuperada (>= 50%) - Resetear notificación para permitir aviso si vuelve a bajar
      await _resetNotificacion(clave);
    }
  }

  Future<void> _mostrarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
    required String idCanal,
    required String nombreCanal,
    required String descripcionCanal,
    required Priority prioridad,
    required Importance importancia,
  }) async {
    await _plugin.show(
      id,
      titulo,
      cuerpo,
      _detallesNotificacion(
        idCanal: idCanal,
        nombreCanal: nombreCanal,
        descripcionCanal: descripcionCanal,
        prioridad: prioridad,
        importancia: importancia,
      ),
    );
  }

  NotificationDetails _detallesNotificacion({
    required String idCanal,
    required String nombreCanal,
    required String descripcionCanal,
    Priority prioridad = Priority.defaultPriority,
    Importance importancia = Importance.defaultImportance,
  }) {
    final detallesAndroid = AndroidNotificationDetails(
      idCanal,
      nombreCanal,
      channelDescription: descripcionCanal,
      importance: importancia,
      priority: prioridad,
      icon: 'ic_notificacion',
    );

    const detallesIOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: detallesAndroid, iOS: detallesIOS);
  }

  Future<void> cancelarTodas() async {
    if (!_inicializado) return;
    await _plugin.cancelAll();
  }
}

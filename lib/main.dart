import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routing/rutas.dart';
import 'core/tema/tema_app.dart';
import 'providers/ajustes_provider.dart';
import 'servicios/notificaciones_servicio.dart';

Future<void> main() async {
  // Aseguramos que Flutter está inicializado antes de Riverpod y los servicios
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Supabase con URL y clave pública del proyecto
  await Supabase.initialize(
    url: 'https://gazskydmqbtpzmudrnos.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhenNreWRtcWJ0cHptdWRybm9zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNzAzNDIsImV4cCI6MjA4OTk0NjM0Mn0.5pu5aLcOzQfrMzxbvW7CiWKndxL9qolgokYVprKBkdU'',
  );

  // Inicializamos el servicio de notificaciones locales y programamos el
  // recordatorio periódico de actualización de kilometraje (cada 15 días)
  final notificaciones = NotificacionesServicio();
  await notificaciones.inicializar();
  // Limpiamos el caché de debounce al arrancar para evitar que claves antiguas
  // (de versiones previas con bug de instancia) bloqueen las notificaciones.
  await notificaciones.resetearCacheNotificaciones();
  await notificaciones.programarRecordatorioKilometraje();

  runApp(
    // ProviderScope de Riverpod envuelve toda la app
    const ProviderScope(child: TallerApp()),
  );
}

class TallerApp extends ConsumerWidget {
  const TallerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos los ajustes (tema e idioma) reactivamente
    final estadoAjustes = ref.watch(ajustesProvider);

    return MaterialApp.router(
      title: 'Taller Personal',
      debugShowCheckedModeBanner: false,

      // Configuración de Theme
      theme: TemaApp.temaClaro,
      darkTheme: TemaApp.temaOscuro,
      themeMode: estadoAjustes.themeMode,

      // Configuración de Internacionalización (i18n)
      locale: estadoAjustes.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), 
        Locale('en'),
        Locale('fr'),
        Locale('pt'),
        Locale('it'),
        Locale('de')
      ],

      // Configuración de GoRouter
      routerConfig: enrutadorApp,
    );
  }
}

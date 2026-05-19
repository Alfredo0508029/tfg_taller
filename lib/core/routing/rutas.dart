import 'package:go_router/go_router.dart';
import '../../data/modelos/vehiculo.dart';
import '../../presentation/pantallas/vehiculos/lista_vehiculos_pantalla.dart';
import '../../presentation/pantallas/vehiculos/form_vehiculo_pantalla.dart';
import '../../presentation/pantallas/dashboard/dashboard_pantalla.dart';
import '../../presentation/pantallas/componentes/form_componente_pantalla.dart';
import '../../presentation/pantallas/mantenimiento/registrar_mantenimiento_pantalla.dart';
import '../../presentation/pantallas/repostajes/repostajes_pantalla.dart';
import '../../presentation/pantallas/repostajes/registrar_repostaje_pantalla.dart';
import '../../presentation/pantallas/estadisticas/estadisticas_pantalla.dart';
import '../../presentation/pantallas/ajustes/ajustes_pantalla.dart';
import '../../presentation/pantallas/mantenimiento/historial_pantalla.dart';
import '../../presentation/pantallas/componentes/lista_componentes_pantalla.dart';
import '../../presentation/pantallas/viajes/viaje_screen.dart';
import '../../data/modelos/componente.dart';
import '../../presentation/pantallas/auth/login_pantalla.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Configuración central del enrutamiento de la aplicación usando GoRouter.
final GoRouter enrutadorApp = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final esPantallaLogin = state.matchedLocation == '/login';
    
    // Si no hay token de sesión en vigor y estamos intentando acceder a la app profunda
    if (session == null && !esPantallaLogin) {
      return '/login'; // Fuerza un muro de login a intrusos.
    }
    
    // Si el usuario ya está verificado pero intenta cargar la ventana de Identificación
    if (session != null && esPantallaLogin) {
      return '/'; // Le salta automáticamente al Dashboard principal de sus vehículos.
    }
    
    return null; // Deja continuar la navegación con total normalidad.
  },
  routes: [
    // Pantalla de Login / Registro
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPantalla(),
    ),
    // Pantalla de inicio: Lista de vehículos
    GoRoute(
      path: '/',
      builder: (context, state) => const ListaVehiculosPantalla(),
      routes: [
        // Pantalla de ajustes
        GoRoute(
          path: 'ajustes',
          builder: (context, state) => const AjustesPantalla(),
        ),
        // Pantalla para crear un vehículo nuevo
        GoRoute(
          path: 'nuevo-vehiculo',
          builder: (context, state) => const FormVehiculoPantalla(),
        ),
        // Pantalla para editar un vehículo existente
        GoRoute(
          path: 'editar-vehiculo',
          builder: (context, state) {
            final vehiculo = state.extra as Vehiculo;
            return FormVehiculoPantalla(vehiculo: vehiculo);
          },
        ),
        // Dashboard principal de un vehículo seleccionado
        GoRoute(
          path: 'vehiculo/:id',
          builder: (context, state) => const DashboardPantalla(),
          routes: [
            // Lista completa de componentes
            GoRoute(
              path: 'componentes',
              builder: (context, state) => const ListaComponentesPantalla(),
              routes: [
                GoRoute(
                  path: 'nuevo',
                  builder: (context, state) => const FormComponentePantalla(),
                ),
                GoRoute(
                  path: 'editar',
                  builder: (context, state) {
                    final componente = state.extra as Componente;
                    return FormComponentePantalla(componente: componente);
                  },
                ),
              ],
            ),
            // Historial de mantenimiento
            GoRoute(
              path: 'historial',
              builder: (context, state) => const HistorialPantalla(),
              routes: [
                GoRoute(
                  path: 'registrar',
                  builder: (context, state) =>
                      const RegistrarMantenimientoPantalla(),
                ),
              ],
            ),
            // Estadísticas del vehículo
            GoRoute(
              path: 'estadisticas',
              builder: (context, state) => const EstadisticasPantalla(),
            ),
            // Simulador de viajes
            GoRoute(
              path: 'simulador-viaje',
              builder: (context, state) => const ViajeScreen(),
            ),
            GoRoute(
              path: 'repostajes',
              builder: (context, state) => const RepostajesPantalla(),
              routes: [
                GoRoute(
                  path: 'registrar',
                  builder: (context, state) => const RegistrarRepostajePantalla(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

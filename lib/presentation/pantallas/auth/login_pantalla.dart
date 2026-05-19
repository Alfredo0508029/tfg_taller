import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

/// Pantalla principal para la autenticación de usuarios.
/// Gestiona tanto el inicio de sesión como el registro de nuevas cuentas
/// interactuando con la API de autenticación nativa de Supabase.
class LoginPantalla extends StatefulWidget {
  const LoginPantalla({super.key});

  @override
  State<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends State<LoginPantalla> {
  /// Controlador para gestionar el texto introducido en el campo del correo electrónico.
  final _emailController = TextEditingController();
  
  /// Controlador para gestionar el texto introducido en el campo de la contraseña.
  final _passwordController = TextEditingController();
  
  /// Estado interno que determina si la vista actual muestra el formulario
  /// de Iniciar Sesión (true) o el formulario de Crear Cuenta Nueva (false).
  bool _esInicioSesion = true;
  
  /// Indicador visual de espera. Se establece a true mientras se realiza
  /// la petición asíncrona a la base de datos de Supabase para evitar dobles envíos.
  bool _estaCargando = false;

  @override
  void dispose() {
    // Es vital liberar la memoria de los controladores de texto cuando 
    // el widget sea destruido para evitar fugas de memoria (memory leaks).
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Método asíncrono que procesa la validación y el envío del formulario.
  /// Contiene la lógica central de autenticación de Supabase (Login y Sign Up).
  Future<void> _procesarFormulario() async {
    // Activamos el indicador de carga y notificamos a la interfaz.
    setState(() => _estaCargando = true);
    try {
      // Limpiamos los espacios en blanco sobrantes antes y después del texto.
      final correoElectronico = _emailController.text.trim();
      final contrasena = _passwordController.text.trim();
      
      if (_esInicioSesion) {
        // Petición para loguear un usuario existente.
        await Supabase.instance.client.auth.signInWithPassword(
          email: correoElectronico,
          password: contrasena,
        );
      } else {
        // Petición para registrar un nuevo usuario en auth.users.
        await Supabase.instance.client.auth.signUp(
          email: correoElectronico,
          password: contrasena,
        );
        // Nota: Si 'Confirm email' está desactivado en Supabase, el registro
        // inicia la sesión automáticamente y GoRouter se encarga de redirigir 
        // a la pantalla principal (ListaVehiculosPantalla).
      }
    } on AuthException catch (e) {
      if (mounted) {
        // Si Supabase devuelve un error controlado (ej: Correo inválido,Rate Limit),
        // lo informamos al usuario dibujando una barra roja de error en la parte inferior.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        // Para cualquier otra excepción no contemplada (ej: Error de red).
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        // Independientemente de si tuvo éxito o falló, desactivamos el anillo de carga.
        setState(() => _estaCargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tema actual de la app (Claro u Oscuro) para usar sus colores corporativos.
    final tema = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      // La barra superior de la app cambiará su título dinámicamente según el modo en que estemos.
      appBar: AppBar(title: Text(_esInicioSesion ? l10n.login : l10n.register)),
      body: Center(
        // SingleChildScrollView permite hacer scroll si el teclado virtual del móvil tapa la pantalla.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logotipo grande en la parte superior del formulario
              Icon(Icons.directions_car, size: 80, color: tema.colorScheme.primary),
              const SizedBox(height: 32),
              
              // Input (Campo de texto) para introducir el Correo Electrónico
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              // Input (Campo de texto) cifrado para introducir la Contraseña
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true, // Oculta los caracteres escritos (por asteriscos o puntos)
              ),
              const SizedBox(height: 24),
              
              // Renderizado condicional: si está cargando, muestra animación. Si no, muestra el botón.
              if (_estaCargando)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _procesarFormulario,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _esInicioSesion ? l10n.enter : l10n.register,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Botón transparente para conmutar entre los formularios de "Iniciar Sesión" y "Registro"
              TextButton(
                onPressed: () {
                  // Prevenimos que el usuario intente cambiar de modo mientras se espera por el servidor
                  if (!_estaCargando) {
                    setState(() => _esInicioSesion = !_esInicioSesion);
                  }
                },
                child: Text(_esInicioSesion ? l10n.dontHaveAccount : l10n.alreadyHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

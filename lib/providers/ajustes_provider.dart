import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Claves de almacenamiento en SharedPreferences
const String _clavesModoOscuro = 'modo_oscuro';
const String _claveIdioma = 'idioma';

/// Estado de los ajustes de la aplicación.
class EstadoAjustes {
  /// Si la app usa el modo oscuro.
  final bool modoOscuro;

  /// Código de idioma activo ('es' o 'en').
  final String idioma;

  const EstadoAjustes({this.modoOscuro = false, this.idioma = 'es'});

  EstadoAjustes copyWith({bool? modoOscuro, String? idioma}) {
    return EstadoAjustes(
      modoOscuro: modoOscuro ?? this.modoOscuro,
      idioma: idioma ?? this.idioma,
    );
  }

  /// Devuelve el ThemeMode según el estado.
  ThemeMode get themeMode => modoOscuro ? ThemeMode.dark : ThemeMode.light;

  /// Devuelve el Locale según el idioma configurado.
  Locale get locale => Locale(idioma);
}

/// Notifier que gestiona los ajustes persistentes de la aplicación.
class AjustesNotifier extends StateNotifier<EstadoAjustes> {
  AjustesNotifier() : super(const EstadoAjustes()) {
    _cargarAjustes();
  }

  /// Carga los ajustes guardados en SharedPreferences al arrancar.
  Future<void> _cargarAjustes() async {
    final prefs = await SharedPreferences.getInstance();
    state = EstadoAjustes(
      modoOscuro: prefs.getBool(_clavesModoOscuro) ?? false,
      idioma: prefs.getString(_claveIdioma) ?? 'es',
    );
  }

  /// Cambia entre modo claro y oscuro y persiste la preferencia.
  Future<void> cambiarTema(bool modoOscuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clavesModoOscuro, modoOscuro);
    state = state.copyWith(modoOscuro: modoOscuro);
  }

  /// Cambia el idioma de la aplicación y persiste la preferencia.
  Future<void> cambiarIdioma(String codigo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveIdioma, codigo);
    state = state.copyWith(idioma: codigo);
  }
}

/// Provider global de los ajustes de la aplicación.
final ajustesProvider = StateNotifierProvider<AjustesNotifier, EstadoAjustes>((
  ref,
) {
  return AjustesNotifier();
});

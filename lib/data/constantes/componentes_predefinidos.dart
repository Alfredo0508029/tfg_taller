import '../../l10n/app_localizations.dart';

/// Componentes predefinidos con intervalos de mantenimiento recomendados.
/// Estos valores son orientativos y el usuario puede personalizarlos.
class ComponentesPredefinidos {
  /// Lista de componentes comunes con sus intervalos recomendados y clave de traducción.
  static const List<Map<String, dynamic>> _datos = [
    {'key': 'comp_engine_oil', 'intervaloKm': 10000},
    {'key': 'comp_oil_filter', 'intervaloKm': 10000},
    {'key': 'comp_air_filter', 'intervaloKm': 20000},
    {'key': 'comp_cabin_filter', 'intervaloKm': 15000},
    {'key': 'comp_fuel_filter', 'intervaloKm': 40000},
    {'key': 'comp_front_brake_pads', 'intervaloKm': 30000},
    {'key': 'comp_rear_brake_pads', 'intervaloKm': 50000},
    {'key': 'comp_front_brake_discs', 'intervaloKm': 80000},
    {'key': 'comp_rear_brake_discs', 'intervaloKm': 100000},
    {'key': 'comp_timing_belt', 'intervaloKm': 80000},
    {'key': 'comp_auxiliary_belt', 'intervaloKm': 60000},
    {'key': 'comp_brake_fluid', 'intervaloKm': 40000},
    {'key': 'comp_coolant', 'intervaloKm': 60000},
    {'key': 'comp_power_steering_fluid', 'intervaloKm': 60000},
    {'key': 'comp_spark_plugs', 'intervaloKm': 30000},
    {'key': 'comp_tires', 'intervaloKm': 40000},
    {'key': 'comp_battery', 'intervaloKm': 80000},
    {'key': 'comp_shock_absorbers', 'intervaloKm': 80000},
    {'key': 'comp_steering_joints', 'intervaloKm': 60000},
    {'key': 'comp_clutch_kit', 'intervaloKm': 100000},
  ];

  /// Retorna la lista de sugerencias con el nombre ya traducido.
  static List<Map<String, dynamic>> obtenerSugerencias(AppLocalizations l10n) {
    return _datos.map((d) {
      final key = d['key'] as String;
      String nombre;

      // Mapeo manual de claves a getters de l10n
      switch (key) {
        case 'comp_engine_oil': nombre = l10n.comp_engine_oil; break;
        case 'comp_oil_filter': nombre = l10n.comp_oil_filter; break;
        case 'comp_air_filter': nombre = l10n.comp_air_filter; break;
        case 'comp_cabin_filter': nombre = l10n.comp_cabin_filter; break;
        case 'comp_fuel_filter': nombre = l10n.comp_fuel_filter; break;
        case 'comp_front_brake_pads': nombre = l10n.comp_front_brake_pads; break;
        case 'comp_rear_brake_pads': nombre = l10n.comp_rear_brake_pads; break;
        case 'comp_front_brake_discs': nombre = l10n.comp_front_brake_discs; break;
        case 'comp_rear_brake_discs': nombre = l10n.comp_rear_brake_discs; break;
        case 'comp_timing_belt': nombre = l10n.comp_timing_belt; break;
        case 'comp_auxiliary_belt': nombre = l10n.comp_auxiliary_belt; break;
        case 'comp_brake_fluid': nombre = l10n.comp_brake_fluid; break;
        case 'comp_coolant': nombre = l10n.comp_coolant; break;
        case 'comp_power_steering_fluid': nombre = l10n.comp_power_steering_fluid; break;
        case 'comp_spark_plugs': nombre = l10n.comp_spark_plugs; break;
        case 'comp_tires': nombre = l10n.comp_tires; break;
        case 'comp_battery': nombre = l10n.comp_battery; break;
        case 'comp_shock_absorbers': nombre = l10n.comp_shock_absorbers; break;
        case 'comp_steering_joints': nombre = l10n.comp_steering_joints; break;
        case 'comp_clutch_kit': nombre = l10n.comp_clutch_kit; break;
        default: nombre = key;
      }

      return {
        'nombre': nombre,
        'intervaloKm': d['intervaloKm'],
      };
    }).toList();
  }
}

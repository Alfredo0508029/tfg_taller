// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Taller Personal';

  @override
  String get vehicles => 'Vehículos';

  @override
  String get noVehicles => 'No tienes vehículos registrados';

  @override
  String get addVehicle => 'Añadir Vehículo';

  @override
  String get editVehicle => 'Editar Vehículo';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modelo';

  @override
  String get year => 'Año';

  @override
  String get currentMileage => 'Kilometraje actual';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get components => 'Componentes';

  @override
  String get history => 'Historial';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get settings => 'Ajustes';

  @override
  String get addComponent => 'Añadir Componente';

  @override
  String get editComponent => 'Editar Componente';

  @override
  String get componentName => 'Nombre del componente';

  @override
  String get replacementInterval => 'Intervalo de sustitución (km)';

  @override
  String get lastChangeMileage => 'Km en el último cambio';

  @override
  String get okStatus => 'OK';

  @override
  String get upcomingStatus => 'Próximo';

  @override
  String get urgentStatus => 'Urgente';

  @override
  String remainingKm(Object km) {
    return '$km km restantes';
  }

  @override
  String overdueKm(Object km) {
    return '¡Atrasado por $km km!';
  }

  @override
  String get registerMaintenance => 'Registrar Mantenimiento';

  @override
  String get maintenanceDate => 'Fecha del mantenimiento';

  @override
  String get kmAtChange => 'Kilometraje en el cambio';

  @override
  String get notes => 'Notas (Opcional)';

  @override
  String get noHistory => 'No hay historial de mantenimiento';

  @override
  String get totalMaintenances => 'Mantenimientos totales';

  @override
  String get frequentComponents => 'Componentes más frecuentes';

  @override
  String get noData => 'No hay datos suficientes';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francês';

  @override
  String get portuguese => 'Portugués';

  @override
  String get italian => 'Italiano';

  @override
  String get german => 'Alemán';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteVehicleConfirm =>
      '¿Estás seguro de que quieres eliminar este vehículo? Se borrarán todos sus datos y el historial de mantenimiento.';

  @override
  String get deleteComponentConfirm =>
      '¿Estás seguro de que quieres eliminar este componente y todo su historial?';

  @override
  String get requiredField => 'Este campo es obligatorio';

  @override
  String get invalidNumber => 'Introduce un número válido';

  @override
  String get comp_engine_oil => 'Aceite del motor';

  @override
  String get comp_oil_filter => 'Filtro de aceite';

  @override
  String get comp_air_filter => 'Filtro de aire';

  @override
  String get comp_cabin_filter => 'Filtro de habitáculo (Polen)';

  @override
  String get comp_fuel_filter => 'Filtro de combustible';

  @override
  String get comp_front_brake_pads => 'Pastillas de freno delanteras';

  @override
  String get comp_rear_brake_pads => 'Pastillas de freno traseras';

  @override
  String get comp_front_brake_discs => 'Discos de freno delanteros';

  @override
  String get comp_rear_brake_discs => 'Discos de freno traseros';

  @override
  String get comp_timing_belt => 'Correa de distribución';

  @override
  String get comp_auxiliary_belt => 'Correa auxiliar (Serpentín)';

  @override
  String get comp_brake_fluid => 'Líquido de frenos';

  @override
  String get comp_coolant => 'Líquido refrigerante';

  @override
  String get comp_power_steering_fluid => 'Líquido de dirección asistida';

  @override
  String get comp_spark_plugs => 'Bujías';

  @override
  String get comp_tires => 'Neumáticos';

  @override
  String get comp_battery => 'Batería';

  @override
  String get comp_shock_absorbers => 'Amortiguadores';

  @override
  String get comp_steering_joints => 'Rótulas de dirección';

  @override
  String get comp_clutch_kit => 'Kit de embrague';

  @override
  String get fuel_gasoline => 'Gasolina';

  @override
  String get fuel_diesel => 'Diésel';

  @override
  String get fuel_electric => 'Eléctrico';

  @override
  String get fuel_hybrid => 'Híbrido';

  @override
  String get quickSuggestions => 'Sugerencias rápidas:';

  @override
  String get showLess => 'Mostrar menos';

  @override
  String get showAllSuggestions => 'Mostrar todas las sugerencias';

  @override
  String get registerRefuel => 'Registrar Repostaje';

  @override
  String get refuelDate => 'Fecha del repostaje';

  @override
  String get mileageAtPump => 'Kilometraje en el surtidor';

  @override
  String get kWhCharged => 'kWh cargados';

  @override
  String get litersRefueled => 'Litros repostados';

  @override
  String get totalAmountToPay => 'Importe Total a Pagar';

  @override
  String get registerExpense => 'Registrar Gasto';

  @override
  String get noComponentsRegistered => 'No hay componentes registrados';

  @override
  String get maintenanceCostOptional => 'Coste del mantenimiento (Opcional)';

  @override
  String get pleaseSelectComponent => 'Por favor, selecciona un componente';

  @override
  String get licensePlate => 'Matrícula';

  @override
  String get licensePlateHint => 'Ej: 1234ABC';

  @override
  String get brandHint => 'Ej: Toyota';

  @override
  String get modelHint => 'Ej: Corolla';

  @override
  String get yearHint => 'Ej: 2018';

  @override
  String get fuelType => 'Tipo de Carburante';

  @override
  String get totalMoneyInverted => 'Dinero Total Invertido';

  @override
  String get deleteMaintenanceConfirm =>
      '¿Estás seguro de que quieres eliminar este registro de mantenimiento?';

  @override
  String get appearance => 'Apariencia';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get vehicleNotFound => 'Vehículo no encontrado';

  @override
  String get tripSimulator => 'Simulador Viaje';

  @override
  String get consumptionAndRefuels => 'Consumo & Repostajes';

  @override
  String get healthDiagnosis => 'DIAGNÓSTICO DE SALUD';

  @override
  String moreAlerts(Object count) {
    return '+ $count alertas más...';
  }

  @override
  String get addRefuel => 'Añadir repostaje';

  @override
  String get refuelHistory => 'Historial de Repostajes';

  @override
  String get noRefuelsYet => 'Aún no hay repostajes.';

  @override
  String get globalAverageConsumption => 'Consumo Medio Global';

  @override
  String get costPerKm => 'Coste por kilómetro';

  @override
  String get amount => 'Cantidad';

  @override
  String get segmentConsumption => 'Consumo tramo';

  @override
  String get unitPrice => 'Precio Unidad';

  @override
  String get deleteRefuel => 'Eliminar Repostaje';

  @override
  String get deleteRefuelConfirm =>
      '¿Estás seguro de que quieres eliminar este registro de repostaje? Se recalcularán las medias de consumo.';

  @override
  String get closeImage => 'Cerrar imagen';

  @override
  String get planNextAdventure => 'Planifica tu próxima aventura';

  @override
  String get analyzeImpact =>
      'Analiza el impacto del kilometraje en tus piezas';

  @override
  String get simulate => 'Simular';

  @override
  String get filterCriticalOnly => 'Filtrar solo advertencias crítico';

  @override
  String get highRiskTrip => 'Viaje de Alto Riesgo';

  @override
  String get requiresAttention => 'Requiere Atención';

  @override
  String get safeTrip => 'Viaje Seguro';

  @override
  String get critical => 'CRÍTICO';

  @override
  String componentsWillExceed(Object count) {
    return 'Se detectaron $count componentes que excederán su límite.';
  }

  @override
  String piecesNearMaintenance(Object count) {
    return 'Atención a $count piezas próximas a su mantenimiento.';
  }

  @override
  String get everythingInOrder =>
      'Todo parece estar en orden para tu trayecto.';

  @override
  String get selectVehicleFirst => 'Selecciona un vehículo primero.';

  @override
  String get destinationOrTripName => 'Destino o nombre del viaje';

  @override
  String get totalKms => 'Kms totales';

  @override
  String get goodHealth => 'Buen estado';

  @override
  String get checkHealth => 'Requiere revisión';

  @override
  String get urgentHealth => 'Mantenimiento urgente';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get enter => 'Entrar';

  @override
  String get dontHaveAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get current => 'Actual';

  @override
  String get afterTrip => 'Post-viaje';
}

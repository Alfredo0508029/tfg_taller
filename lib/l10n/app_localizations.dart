import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// El título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'Taller Personal'**
  String get appTitle;

  /// No description provided for @vehicles.
  ///
  /// In es, this message translates to:
  /// **'Vehículos'**
  String get vehicles;

  /// No description provided for @noVehicles.
  ///
  /// In es, this message translates to:
  /// **'No tienes vehículos registrados'**
  String get noVehicles;

  /// No description provided for @addVehicle.
  ///
  /// In es, this message translates to:
  /// **'Añadir Vehículo'**
  String get addVehicle;

  /// No description provided for @editVehicle.
  ///
  /// In es, this message translates to:
  /// **'Editar Vehículo'**
  String get editVehicle;

  /// No description provided for @brand.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In es, this message translates to:
  /// **'Modelo'**
  String get model;

  /// No description provided for @year.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get year;

  /// No description provided for @currentMileage.
  ///
  /// In es, this message translates to:
  /// **'Kilometraje actual'**
  String get currentMileage;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @dashboard.
  ///
  /// In es, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @components.
  ///
  /// In es, this message translates to:
  /// **'Componentes'**
  String get components;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get history;

  /// No description provided for @statistics.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @addComponent.
  ///
  /// In es, this message translates to:
  /// **'Añadir Componente'**
  String get addComponent;

  /// No description provided for @editComponent.
  ///
  /// In es, this message translates to:
  /// **'Editar Componente'**
  String get editComponent;

  /// No description provided for @componentName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del componente'**
  String get componentName;

  /// No description provided for @replacementInterval.
  ///
  /// In es, this message translates to:
  /// **'Intervalo de sustitución (km)'**
  String get replacementInterval;

  /// No description provided for @lastChangeMileage.
  ///
  /// In es, this message translates to:
  /// **'Km en el último cambio'**
  String get lastChangeMileage;

  /// No description provided for @okStatus.
  ///
  /// In es, this message translates to:
  /// **'OK'**
  String get okStatus;

  /// No description provided for @upcomingStatus.
  ///
  /// In es, this message translates to:
  /// **'Próximo'**
  String get upcomingStatus;

  /// No description provided for @urgentStatus.
  ///
  /// In es, this message translates to:
  /// **'Urgente'**
  String get urgentStatus;

  /// No description provided for @remainingKm.
  ///
  /// In es, this message translates to:
  /// **'{km} km restantes'**
  String remainingKm(Object km);

  /// No description provided for @overdueKm.
  ///
  /// In es, this message translates to:
  /// **'¡Atrasado por {km} km!'**
  String overdueKm(Object km);

  /// No description provided for @registerMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Registrar Mantenimiento'**
  String get registerMaintenance;

  /// No description provided for @maintenanceDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del mantenimiento'**
  String get maintenanceDate;

  /// No description provided for @kmAtChange.
  ///
  /// In es, this message translates to:
  /// **'Kilometraje en el cambio'**
  String get kmAtChange;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas (Opcional)'**
  String get notes;

  /// No description provided for @noHistory.
  ///
  /// In es, this message translates to:
  /// **'No hay historial de mantenimiento'**
  String get noHistory;

  /// No description provided for @totalMaintenances.
  ///
  /// In es, this message translates to:
  /// **'Mantenimientos totales'**
  String get totalMaintenances;

  /// No description provided for @frequentComponents.
  ///
  /// In es, this message translates to:
  /// **'Componentes más frecuentes'**
  String get frequentComponents;

  /// No description provided for @noData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos suficientes'**
  String get noData;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @french.
  ///
  /// In es, this message translates to:
  /// **'Francês'**
  String get french;

  /// No description provided for @portuguese.
  ///
  /// In es, this message translates to:
  /// **'Portugués'**
  String get portuguese;

  /// No description provided for @italian.
  ///
  /// In es, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @german.
  ///
  /// In es, this message translates to:
  /// **'Alemán'**
  String get german;

  /// No description provided for @darkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Claro'**
  String get lightMode;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @deleteVehicleConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar este vehículo? Se borrarán todos sus datos y el historial de mantenimiento.'**
  String get deleteVehicleConfirm;

  /// No description provided for @deleteComponentConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar este componente y todo su historial?'**
  String get deleteComponentConfirm;

  /// No description provided for @requiredField.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Introduce un número válido'**
  String get invalidNumber;

  /// No description provided for @comp_engine_oil.
  ///
  /// In es, this message translates to:
  /// **'Aceite del motor'**
  String get comp_engine_oil;

  /// No description provided for @comp_oil_filter.
  ///
  /// In es, this message translates to:
  /// **'Filtro de aceite'**
  String get comp_oil_filter;

  /// No description provided for @comp_air_filter.
  ///
  /// In es, this message translates to:
  /// **'Filtro de aire'**
  String get comp_air_filter;

  /// No description provided for @comp_cabin_filter.
  ///
  /// In es, this message translates to:
  /// **'Filtro de habitáculo (Polen)'**
  String get comp_cabin_filter;

  /// No description provided for @comp_fuel_filter.
  ///
  /// In es, this message translates to:
  /// **'Filtro de combustible'**
  String get comp_fuel_filter;

  /// No description provided for @comp_front_brake_pads.
  ///
  /// In es, this message translates to:
  /// **'Pastillas de freno delanteras'**
  String get comp_front_brake_pads;

  /// No description provided for @comp_rear_brake_pads.
  ///
  /// In es, this message translates to:
  /// **'Pastillas de freno traseras'**
  String get comp_rear_brake_pads;

  /// No description provided for @comp_front_brake_discs.
  ///
  /// In es, this message translates to:
  /// **'Discos de freno delanteros'**
  String get comp_front_brake_discs;

  /// No description provided for @comp_rear_brake_discs.
  ///
  /// In es, this message translates to:
  /// **'Discos de freno traseros'**
  String get comp_rear_brake_discs;

  /// No description provided for @comp_timing_belt.
  ///
  /// In es, this message translates to:
  /// **'Correa de distribución'**
  String get comp_timing_belt;

  /// No description provided for @comp_auxiliary_belt.
  ///
  /// In es, this message translates to:
  /// **'Correa auxiliar (Serpentín)'**
  String get comp_auxiliary_belt;

  /// No description provided for @comp_brake_fluid.
  ///
  /// In es, this message translates to:
  /// **'Líquido de frenos'**
  String get comp_brake_fluid;

  /// No description provided for @comp_coolant.
  ///
  /// In es, this message translates to:
  /// **'Líquido refrigerante'**
  String get comp_coolant;

  /// No description provided for @comp_power_steering_fluid.
  ///
  /// In es, this message translates to:
  /// **'Líquido de dirección asistida'**
  String get comp_power_steering_fluid;

  /// No description provided for @comp_spark_plugs.
  ///
  /// In es, this message translates to:
  /// **'Bujías'**
  String get comp_spark_plugs;

  /// No description provided for @comp_tires.
  ///
  /// In es, this message translates to:
  /// **'Neumáticos'**
  String get comp_tires;

  /// No description provided for @comp_battery.
  ///
  /// In es, this message translates to:
  /// **'Batería'**
  String get comp_battery;

  /// No description provided for @comp_shock_absorbers.
  ///
  /// In es, this message translates to:
  /// **'Amortiguadores'**
  String get comp_shock_absorbers;

  /// No description provided for @comp_steering_joints.
  ///
  /// In es, this message translates to:
  /// **'Rótulas de dirección'**
  String get comp_steering_joints;

  /// No description provided for @comp_clutch_kit.
  ///
  /// In es, this message translates to:
  /// **'Kit de embrague'**
  String get comp_clutch_kit;

  /// No description provided for @fuel_gasoline.
  ///
  /// In es, this message translates to:
  /// **'Gasolina'**
  String get fuel_gasoline;

  /// No description provided for @fuel_diesel.
  ///
  /// In es, this message translates to:
  /// **'Diésel'**
  String get fuel_diesel;

  /// No description provided for @fuel_electric.
  ///
  /// In es, this message translates to:
  /// **'Eléctrico'**
  String get fuel_electric;

  /// No description provided for @fuel_hybrid.
  ///
  /// In es, this message translates to:
  /// **'Híbrido'**
  String get fuel_hybrid;

  /// No description provided for @quickSuggestions.
  ///
  /// In es, this message translates to:
  /// **'Sugerencias rápidas:'**
  String get quickSuggestions;

  /// No description provided for @showLess.
  ///
  /// In es, this message translates to:
  /// **'Mostrar menos'**
  String get showLess;

  /// No description provided for @showAllSuggestions.
  ///
  /// In es, this message translates to:
  /// **'Mostrar todas las sugerencias'**
  String get showAllSuggestions;

  /// No description provided for @registerRefuel.
  ///
  /// In es, this message translates to:
  /// **'Registrar Repostaje'**
  String get registerRefuel;

  /// No description provided for @refuelDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del repostaje'**
  String get refuelDate;

  /// No description provided for @mileageAtPump.
  ///
  /// In es, this message translates to:
  /// **'Kilometraje en el surtidor'**
  String get mileageAtPump;

  /// No description provided for @kWhCharged.
  ///
  /// In es, this message translates to:
  /// **'kWh cargados'**
  String get kWhCharged;

  /// No description provided for @litersRefueled.
  ///
  /// In es, this message translates to:
  /// **'Litros repostados'**
  String get litersRefueled;

  /// No description provided for @totalAmountToPay.
  ///
  /// In es, this message translates to:
  /// **'Importe Total a Pagar'**
  String get totalAmountToPay;

  /// No description provided for @registerExpense.
  ///
  /// In es, this message translates to:
  /// **'Registrar Gasto'**
  String get registerExpense;

  /// No description provided for @noComponentsRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay componentes registrados'**
  String get noComponentsRegistered;

  /// No description provided for @maintenanceCostOptional.
  ///
  /// In es, this message translates to:
  /// **'Coste del mantenimiento (Opcional)'**
  String get maintenanceCostOptional;

  /// No description provided for @pleaseSelectComponent.
  ///
  /// In es, this message translates to:
  /// **'Por favor, selecciona un componente'**
  String get pleaseSelectComponent;

  /// No description provided for @licensePlate.
  ///
  /// In es, this message translates to:
  /// **'Matrícula'**
  String get licensePlate;

  /// No description provided for @licensePlateHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1234ABC'**
  String get licensePlateHint;

  /// No description provided for @brandHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Toyota'**
  String get brandHint;

  /// No description provided for @modelHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Corolla'**
  String get modelHint;

  /// No description provided for @yearHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 2018'**
  String get yearHint;

  /// No description provided for @fuelType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Carburante'**
  String get fuelType;

  /// No description provided for @totalMoneyInverted.
  ///
  /// In es, this message translates to:
  /// **'Dinero Total Invertido'**
  String get totalMoneyInverted;

  /// No description provided for @deleteMaintenanceConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar este registro de mantenimiento?'**
  String get deleteMaintenanceConfirm;

  /// No description provided for @appearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get appearance;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @vehicleNotFound.
  ///
  /// In es, this message translates to:
  /// **'Vehículo no encontrado'**
  String get vehicleNotFound;

  /// No description provided for @tripSimulator.
  ///
  /// In es, this message translates to:
  /// **'Simulador Viaje'**
  String get tripSimulator;

  /// No description provided for @consumptionAndRefuels.
  ///
  /// In es, this message translates to:
  /// **'Consumo & Repostajes'**
  String get consumptionAndRefuels;

  /// No description provided for @healthDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'DIAGNÓSTICO DE SALUD'**
  String get healthDiagnosis;

  /// No description provided for @moreAlerts.
  ///
  /// In es, this message translates to:
  /// **'+ {count} alertas más...'**
  String moreAlerts(Object count);

  /// No description provided for @addRefuel.
  ///
  /// In es, this message translates to:
  /// **'Añadir repostaje'**
  String get addRefuel;

  /// No description provided for @refuelHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de Repostajes'**
  String get refuelHistory;

  /// No description provided for @noRefuelsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay repostajes.'**
  String get noRefuelsYet;

  /// No description provided for @globalAverageConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo Medio Global'**
  String get globalAverageConsumption;

  /// No description provided for @costPerKm.
  ///
  /// In es, this message translates to:
  /// **'Coste por kilómetro'**
  String get costPerKm;

  /// No description provided for @amount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get amount;

  /// No description provided for @segmentConsumption.
  ///
  /// In es, this message translates to:
  /// **'Consumo tramo'**
  String get segmentConsumption;

  /// No description provided for @unitPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio Unidad'**
  String get unitPrice;

  /// No description provided for @deleteRefuel.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Repostaje'**
  String get deleteRefuel;

  /// No description provided for @deleteRefuelConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar este registro de repostaje? Se recalcularán las medias de consumo.'**
  String get deleteRefuelConfirm;

  /// No description provided for @closeImage.
  ///
  /// In es, this message translates to:
  /// **'Cerrar imagen'**
  String get closeImage;

  /// No description provided for @planNextAdventure.
  ///
  /// In es, this message translates to:
  /// **'Planifica tu próxima aventura'**
  String get planNextAdventure;

  /// No description provided for @analyzeImpact.
  ///
  /// In es, this message translates to:
  /// **'Analiza el impacto del kilometraje en tus piezas'**
  String get analyzeImpact;

  /// No description provided for @simulate.
  ///
  /// In es, this message translates to:
  /// **'Simular'**
  String get simulate;

  /// No description provided for @filterCriticalOnly.
  ///
  /// In es, this message translates to:
  /// **'Filtrar solo advertencias crítico'**
  String get filterCriticalOnly;

  /// No description provided for @highRiskTrip.
  ///
  /// In es, this message translates to:
  /// **'Viaje de Alto Riesgo'**
  String get highRiskTrip;

  /// No description provided for @requiresAttention.
  ///
  /// In es, this message translates to:
  /// **'Requiere Atención'**
  String get requiresAttention;

  /// No description provided for @safeTrip.
  ///
  /// In es, this message translates to:
  /// **'Viaje Seguro'**
  String get safeTrip;

  /// No description provided for @critical.
  ///
  /// In es, this message translates to:
  /// **'CRÍTICO'**
  String get critical;

  /// No description provided for @componentsWillExceed.
  ///
  /// In es, this message translates to:
  /// **'Se detectaron {count} componentes que excederán su límite.'**
  String componentsWillExceed(Object count);

  /// No description provided for @piecesNearMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Atención a {count} piezas próximas a su mantenimiento.'**
  String piecesNearMaintenance(Object count);

  /// No description provided for @everythingInOrder.
  ///
  /// In es, this message translates to:
  /// **'Todo parece estar en orden para tu trayecto.'**
  String get everythingInOrder;

  /// No description provided for @selectVehicleFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un vehículo primero.'**
  String get selectVehicleFirst;

  /// No description provided for @destinationOrTripName.
  ///
  /// In es, this message translates to:
  /// **'Destino o nombre del viaje'**
  String get destinationOrTripName;

  /// No description provided for @totalKms.
  ///
  /// In es, this message translates to:
  /// **'Kms totales'**
  String get totalKms;

  /// No description provided for @goodHealth.
  ///
  /// In es, this message translates to:
  /// **'Buen estado'**
  String get goodHealth;

  /// No description provided for @checkHealth.
  ///
  /// In es, this message translates to:
  /// **'Requiere revisión'**
  String get checkHealth;

  /// No description provided for @urgentHealth.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento urgente'**
  String get urgentHealth;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @enter.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get enter;

  /// No description provided for @dontHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Regístrate'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? Inicia sesión'**
  String get alreadyHaveAccount;

  /// No description provided for @current.
  ///
  /// In es, this message translates to:
  /// **'Actual'**
  String get current;

  /// No description provided for @afterTrip.
  ///
  /// In es, this message translates to:
  /// **'Post-viaje'**
  String get afterTrip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

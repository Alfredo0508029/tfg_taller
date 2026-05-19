// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Persönliche Werkstatt';

  @override
  String get vehicles => 'Fahrzeuge';

  @override
  String get noVehicles => 'Keine Fahrzeuge registriert';

  @override
  String get addVehicle => 'Fahrzeug Hinzufügen';

  @override
  String get editVehicle => 'Fahrzeug Bearbeiten';

  @override
  String get brand => 'Marke';

  @override
  String get model => 'Modell';

  @override
  String get year => 'Jahr';

  @override
  String get currentMileage => 'Aktueller Kilometerstand';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get components => 'Komponenten';

  @override
  String get history => 'Verlauf';

  @override
  String get statistics => 'Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get addComponent => 'Komponente Hinzufügen';

  @override
  String get editComponent => 'Komponente Bearbeiten';

  @override
  String get componentName => 'Name der Komponente';

  @override
  String get replacementInterval => 'Wechselintervall (km)';

  @override
  String get lastChangeMileage => 'Km beim letzten Wechsel';

  @override
  String get okStatus => 'OK';

  @override
  String get upcomingStatus => 'Anstehend';

  @override
  String get urgentStatus => 'Dringend';

  @override
  String remainingKm(Object km) {
    return '$km km verbleibend';
  }

  @override
  String overdueKm(Object km) {
    return 'Überfällig um $km km!';
  }

  @override
  String get registerMaintenance => 'Wartung Registrieren';

  @override
  String get maintenanceDate => 'Datum der Wartung';

  @override
  String get kmAtChange => 'Kilometerstand beim Wechsel';

  @override
  String get notes => 'Notizen (Optional)';

  @override
  String get noHistory => 'Kein Wartungsverlauf';

  @override
  String get totalMaintenances => 'Gesamte Wartungen';

  @override
  String get frequentComponents => 'Häufigste Komponenten';

  @override
  String get noData => 'Nicht genügend Daten';

  @override
  String get language => 'Sprache';

  @override
  String get spanish => 'Spanisch';

  @override
  String get english => 'Englisch';

  @override
  String get french => 'Französisch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get german => 'Deutsch';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteVehicleConfirm =>
      'Bist du sicher, dass du dieses Fahrzeug löschen willst? Alle Daten und der Wartungsverlauf werden gelöscht.';

  @override
  String get deleteComponentConfirm =>
      'Bist du sicher, dass du diese Komponente und ihren gesamten Verlauf löschen willst?';

  @override
  String get requiredField => 'Dieses Feld ist erforderlich';

  @override
  String get invalidNumber => 'Bitte gib eine gültige Nummer ein';

  @override
  String get comp_engine_oil => 'Motoröl';

  @override
  String get comp_oil_filter => 'Ölfilter';

  @override
  String get comp_air_filter => 'Luftfilter';

  @override
  String get comp_cabin_filter => 'Innenraumfilter (Pollen)';

  @override
  String get comp_fuel_filter => 'Kraftstofffilter';

  @override
  String get comp_front_brake_pads => 'Bremsbeläge vorne';

  @override
  String get comp_rear_brake_pads => 'Bremsbeläge hinten';

  @override
  String get comp_front_brake_discs => 'Bremsscheiben vorne';

  @override
  String get comp_rear_brake_discs => 'Bremsscheiben hinten';

  @override
  String get comp_timing_belt => 'Zahnriemen';

  @override
  String get comp_auxiliary_belt => 'Keilriemen';

  @override
  String get comp_brake_fluid => 'Bremsflüssigkeit';

  @override
  String get comp_coolant => 'Kühlmittel';

  @override
  String get comp_power_steering_fluid => 'Servolenkungsflüssigkeit';

  @override
  String get comp_spark_plugs => 'Zündkerzen';

  @override
  String get comp_tires => 'Reifen';

  @override
  String get comp_battery => 'Batterie';

  @override
  String get comp_shock_absorbers => 'Stoßdämpfer';

  @override
  String get comp_steering_joints => 'Spurstangenköpfe';

  @override
  String get comp_clutch_kit => 'Kupplungssatz';

  @override
  String get fuel_gasoline => 'Benzin';

  @override
  String get fuel_diesel => 'Diesel';

  @override
  String get fuel_electric => 'Elektro';

  @override
  String get fuel_hybrid => 'Hybrid';

  @override
  String get quickSuggestions => 'Schnelle Vorschläge:';

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String get showAllSuggestions => 'Alle Vorschläge anzeigen';

  @override
  String get registerRefuel => 'Betankung registrieren';

  @override
  String get refuelDate => 'Datum der Betankung';

  @override
  String get mileageAtPump => 'Kilometerstand an der Zapfsäule';

  @override
  String get kWhCharged => 'kWh geladen';

  @override
  String get litersRefueled => 'Liter getankt';

  @override
  String get totalAmountToPay => 'Gesamtbetrag zu zahlen';

  @override
  String get registerExpense => 'Ausgabe registrieren';

  @override
  String get noComponentsRegistered => 'Keine Komponenten registriert';

  @override
  String get maintenanceCostOptional => 'Wartungskosten (Optional)';

  @override
  String get pleaseSelectComponent => 'Bitte wählen Sie eine Komponente aus';

  @override
  String get licensePlate => 'Kennzeichen';

  @override
  String get licensePlateHint => 'z.B.: 1234ABC';

  @override
  String get brandHint => 'z.B.: Toyota';

  @override
  String get modelHint => 'z.B.: Corolla';

  @override
  String get yearHint => 'z.B.: 2018';

  @override
  String get fuelType => 'Kraftstoffart';

  @override
  String get totalMoneyInverted => 'Investiertes Gesamtgeld';

  @override
  String get deleteMaintenanceConfirm =>
      'Bist du sicher, dass du diesen Wartungsnachweis löschen willst?';

  @override
  String get appearance => 'Aussehen';

  @override
  String get logout => 'Abmelden';

  @override
  String get vehicleNotFound => 'Fahrzeug nicht gefunden';

  @override
  String get tripSimulator => 'Reisesimulator';

  @override
  String get consumptionAndRefuels => 'Verbrauch & Betankungen';

  @override
  String get healthDiagnosis => 'GESUNDHEITSDIAGNOSE';

  @override
  String moreAlerts(Object count) {
    return '+ $count weitere Warnungen...';
  }

  @override
  String get addRefuel => 'Betankung hinzufügen';

  @override
  String get refuelHistory => 'Betankungshistorie';

  @override
  String get noRefuelsYet => 'Noch keine Betankungen.';

  @override
  String get globalAverageConsumption => 'Globaler Durchschnittsverbrauch';

  @override
  String get costPerKm => 'Kosten pro Kilometer';

  @override
  String get amount => 'Menge';

  @override
  String get segmentConsumption => 'Segmentverbrauch';

  @override
  String get unitPrice => 'Stückpreis';

  @override
  String get deleteRefuel => 'Betankung löschen';

  @override
  String get deleteRefuelConfirm =>
      'Bist du sicher, dass du diesen Betankungsnachweis löschen willst? Der Durchschnittsverbrauch wird neu berechnet.';

  @override
  String get closeImage => 'Bild schließen';

  @override
  String get planNextAdventure => 'Plane dein nächstes Abenteuer';

  @override
  String get analyzeImpact =>
      'Analysiere die Auswirkungen der Kilometerleistung auf deine Teile';

  @override
  String get simulate => 'Simulieren';

  @override
  String get filterCriticalOnly => 'Nur kritische Warnungen filtern';

  @override
  String get highRiskTrip => 'Hochrisiko-Reise';

  @override
  String get requiresAttention => 'Erfordert Aufmerksamkeit';

  @override
  String get safeTrip => 'Sichere Reise';

  @override
  String get critical => 'KRITISCH';

  @override
  String componentsWillExceed(Object count) {
    return '$count Komponenten werden ihr Limit überschreiten.';
  }

  @override
  String piecesNearMaintenance(Object count) {
    return 'Achtung bei $count Teilen in der Nähe der Wartung.';
  }

  @override
  String get everythingInOrder =>
      'Für deine Reise scheint alles in Ordnung zu sein.';

  @override
  String get selectVehicleFirst => 'Wähle zuerst un Fahrzeug aus.';

  @override
  String get destinationOrTripName => 'Ziel oder Name der Reise';

  @override
  String get totalKms => 'Gesamt-Km';

  @override
  String get goodHealth => 'Guter Zustand';

  @override
  String get checkHealth => 'Prüfung erforderlich';

  @override
  String get urgentHealth => 'Dringende Wartung';

  @override
  String get login => 'Einloggen';

  @override
  String get register => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get enter => 'Eintreten';

  @override
  String get dontHaveAccount => 'Noch kein Konto? Registrieren';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto? Einloggen';

  @override
  String get current => 'Aktuell';

  @override
  String get afterTrip => 'Nach der Reise';
}

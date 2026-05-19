// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Officina Personale';

  @override
  String get vehicles => 'Veicoli';

  @override
  String get noVehicles => 'Nessun veicolo registrato';

  @override
  String get addVehicle => 'Aggiungi Veicolo';

  @override
  String get editVehicle => 'Modifica Veicolo';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modello';

  @override
  String get year => 'Anno';

  @override
  String get currentMileage => 'Chilometraggio Attuale';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get dashboard => 'Cruscotto';

  @override
  String get components => 'Componenti';

  @override
  String get history => 'Cronologia';

  @override
  String get statistics => 'Statistiche';

  @override
  String get settings => 'Impostazioni';

  @override
  String get addComponent => 'Aggiungi Componente';

  @override
  String get editComponent => 'Modifica Componente';

  @override
  String get componentName => 'Nome del componente';

  @override
  String get replacementInterval => 'Intervallo di sostituzione (km)';

  @override
  String get lastChangeMileage => 'Km all\'ultimo cambio';

  @override
  String get okStatus => 'OK';

  @override
  String get upcomingStatus => 'Prossimo';

  @override
  String get urgentStatus => 'Urgente';

  @override
  String remainingKm(Object km) {
    return '$km km rimanenti';
  }

  @override
  String overdueKm(Object km) {
    return 'In ritardo di $km km!';
  }

  @override
  String get registerMaintenance => 'Registra Manutenzione';

  @override
  String get maintenanceDate => 'Data della manutenzione';

  @override
  String get kmAtChange => 'Chilometraggio al cambio';

  @override
  String get notes => 'Note (Opzionale)';

  @override
  String get noHistory => 'Nessuna cronologia di manutenzione';

  @override
  String get totalMaintenances => 'Manutenzioni totali';

  @override
  String get frequentComponents => 'Componenti più frequenti';

  @override
  String get noData => 'Dati insufficienti';

  @override
  String get language => 'Lingua';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get english => 'Inglese';

  @override
  String get french => 'Francese';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get italian => 'Italiano';

  @override
  String get german => 'Tedesco';

  @override
  String get darkMode => 'Modalità Scura';

  @override
  String get lightMode => 'Modalità Chiara';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteVehicleConfirm =>
      'Sei sicuro di voler eliminare questo veicolo? Tutti i suoi dati e la cronologia delle manutenzioni verranno cancellati.';

  @override
  String get deleteComponentConfirm =>
      'Sei sicuro di voler eliminare questo componente e tutta la sua cronologia?';

  @override
  String get requiredField => 'Questo campo è obbligatorio';

  @override
  String get invalidNumber => 'Inserisci un numero valido';

  @override
  String get comp_engine_oil => 'Olio motore';

  @override
  String get comp_oil_filter => 'Filtro olio';

  @override
  String get comp_air_filter => 'Filtro aria';

  @override
  String get comp_cabin_filter => 'Filtro abitacolo (Polline)';

  @override
  String get comp_fuel_filter => 'Filtro carburante';

  @override
  String get comp_front_brake_pads => 'Pastiglie freno anteriori';

  @override
  String get comp_rear_brake_pads => 'Pastiglie freno posteriori';

  @override
  String get comp_front_brake_discs => 'Dischi freno anteriori';

  @override
  String get comp_rear_brake_discs => 'Dischi freno posteriori';

  @override
  String get comp_timing_belt => 'Cinghia di distribuzione';

  @override
  String get comp_auxiliary_belt => 'Cinghia servizi';

  @override
  String get comp_brake_fluid => 'Liquido freni';

  @override
  String get comp_coolant => 'Liquido refrigerante';

  @override
  String get comp_power_steering_fluid => 'Liquido servosterzo';

  @override
  String get comp_spark_plugs => 'Candele';

  @override
  String get comp_tires => 'Pneumatici';

  @override
  String get comp_battery => 'Batteria';

  @override
  String get comp_shock_absorbers => 'Ammortizzatori';

  @override
  String get comp_steering_joints => 'Giunti dello sterzo';

  @override
  String get comp_clutch_kit => 'Kit frizione';

  @override
  String get fuel_gasoline => 'Benzina';

  @override
  String get fuel_diesel => 'Diesel';

  @override
  String get fuel_electric => 'Elettrico';

  @override
  String get fuel_hybrid => 'Ibrido';

  @override
  String get quickSuggestions => 'Suggerimenti rapidi:';

  @override
  String get showLess => 'Mostra meno';

  @override
  String get showAllSuggestions => 'Mostra tutti i suggerimenti';

  @override
  String get registerRefuel => 'Registra rifornimento';

  @override
  String get refuelDate => 'Data del rifornimento';

  @override
  String get mileageAtPump => 'Chilometraggio alla pompa';

  @override
  String get kWhCharged => 'kWh caricati';

  @override
  String get litersRefueled => 'Litri riforniti';

  @override
  String get totalAmountToPay => 'Importo totale da pagare';

  @override
  String get registerExpense => 'Registra spesa';

  @override
  String get noComponentsRegistered => 'Nessun componente registrato';

  @override
  String get maintenanceCostOptional => 'Costo della manutenzione (Opzionale)';

  @override
  String get pleaseSelectComponent => 'Per favore, seleziona un componente';

  @override
  String get licensePlate => 'Targa';

  @override
  String get licensePlateHint => 'Es: 1234ABC';

  @override
  String get brandHint => 'Es: Toyota';

  @override
  String get modelHint => 'Es: Corolla';

  @override
  String get yearHint => 'Es: 2018';

  @override
  String get fuelType => 'Tipo di Carburante';

  @override
  String get totalMoneyInverted => 'Denaro Totale Investito';

  @override
  String get deleteMaintenanceConfirm =>
      'Sei sicuro di voler eliminare questo record di manutenzione?';

  @override
  String get appearance => 'Aspetto';

  @override
  String get logout => 'Disconnettersi';

  @override
  String get vehicleNotFound => 'Veicolo non trovato';

  @override
  String get tripSimulator => 'Simulatore di Viaggio';

  @override
  String get consumptionAndRefuels => 'Consumo & Rifornimenti';

  @override
  String get healthDiagnosis => 'DIAGNOSI DELLA SALUTE';

  @override
  String moreAlerts(Object count) {
    return '+ $count altre segnalazioni...';
  }

  @override
  String get addRefuel => 'Aggiungi rifornimento';

  @override
  String get refuelHistory => 'Cronologia Rifornimenti';

  @override
  String get noRefuelsYet => 'Ancora nessun rifornimento.';

  @override
  String get globalAverageConsumption => 'Consumo Medio Globale';

  @override
  String get costPerKm => 'Costo per chilometro';

  @override
  String get amount => 'Quantità';

  @override
  String get segmentConsumption => 'Consumo tratto';

  @override
  String get unitPrice => 'Prezzo Unitario';

  @override
  String get deleteRefuel => 'Elimina Rifornimento';

  @override
  String get deleteRefuelConfirm =>
      'Sei sicuro di voler eliminare questo record di rifornimento? Le medie di consumo verranno ricalcolate.';

  @override
  String get closeImage => 'Chiudi immagine';

  @override
  String get planNextAdventure => 'Pianifica la tua prossima avventura';

  @override
  String get analyzeImpact =>
      'Analizza l\'impatto del chilometraggio sui tuoi componenti';

  @override
  String get simulate => 'Simula';

  @override
  String get filterCriticalOnly => 'Filtra solo avvisi critici';

  @override
  String get highRiskTrip => 'Viaggio ad Alto Rischio';

  @override
  String get requiresAttention => 'Richiede Attenzione';

  @override
  String get safeTrip => 'Viaggio Sicuro';

  @override
  String get critical => 'CRITICO';

  @override
  String componentsWillExceed(Object count) {
    return 'Rilevati $count componenti che supereranno il limite.';
  }

  @override
  String piecesNearMaintenance(Object count) {
    return 'Attenzione a $count componenti prossimi alla manutenzione.';
  }

  @override
  String get everythingInOrder => 'Tutto sembra in ordine per il tuo tragitto.';

  @override
  String get selectVehicleFirst => 'Seleziona prima un veicolo.';

  @override
  String get destinationOrTripName => 'Destinazione o nome del viaggio';

  @override
  String get totalKms => 'Km totali';

  @override
  String get goodHealth => 'Buono stato';

  @override
  String get checkHealth => 'Revisione richiesta';

  @override
  String get urgentHealth => 'Manutenzione urgente';

  @override
  String get login => 'Accedi';

  @override
  String get register => 'Registrati';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enter => 'Entra';

  @override
  String get dontHaveAccount => 'Non hai un account? Registrati';

  @override
  String get alreadyHaveAccount => 'Hai già un account? Accedi';

  @override
  String get current => 'Attuale';

  @override
  String get afterTrip => 'Dopo il viaggio';
}

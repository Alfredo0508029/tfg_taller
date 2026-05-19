// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Garage Personnel';

  @override
  String get vehicles => 'Véhicules';

  @override
  String get noVehicles => 'Aucun véhicule enregistré';

  @override
  String get addVehicle => 'Ajouter un Véhicule';

  @override
  String get editVehicle => 'Modifier le Véhicule';

  @override
  String get brand => 'Marque';

  @override
  String get model => 'Modèle';

  @override
  String get year => 'Année';

  @override
  String get currentMileage => 'Kilométrage Actuel';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get components => 'Composants';

  @override
  String get history => 'Historique';

  @override
  String get statistics => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get addComponent => 'Ajouter un Composant';

  @override
  String get editComponent => 'Modifier le Composant';

  @override
  String get componentName => 'Nom du composant';

  @override
  String get replacementInterval => 'Intervalle de remplacement (km)';

  @override
  String get lastChangeMileage => 'Kilométrage au dernier changement';

  @override
  String get okStatus => 'OK';

  @override
  String get upcomingStatus => 'À venir';

  @override
  String get urgentStatus => 'Urgent';

  @override
  String remainingKm(Object km) {
    return '$km km restants';
  }

  @override
  String overdueKm(Object km) {
    return 'En retard de $km km !';
  }

  @override
  String get registerMaintenance => 'Enregistrer un Entretien';

  @override
  String get maintenanceDate => 'Date de l\'entretien';

  @override
  String get kmAtChange => 'Kilométrage lors du changement';

  @override
  String get notes => 'Notes (Optionnel)';

  @override
  String get noHistory => 'Aucun historique d\'entretien';

  @override
  String get totalMaintenances => 'Entretiens totaux';

  @override
  String get frequentComponents => 'Composants les plus fréquents';

  @override
  String get noData => 'Pas assez de données';

  @override
  String get language => 'Langue';

  @override
  String get spanish => 'Espagnol';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get portuguese => 'Portugais';

  @override
  String get italian => 'Italien';

  @override
  String get german => 'Allemand';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get lightMode => 'Mode Clair';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteVehicleConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce véhicule ? Toutes ses données et l\'historique d\'entretien seront effacés.';

  @override
  String get deleteComponentConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce composant et tout son historique ?';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get invalidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get comp_engine_oil => 'Huile moteur';

  @override
  String get comp_oil_filter => 'Filtre à huile';

  @override
  String get comp_air_filter => 'Filtre à air';

  @override
  String get comp_cabin_filter => 'Filtre d\'habitacle (Pollen)';

  @override
  String get comp_fuel_filter => 'Filtre à carburant';

  @override
  String get comp_front_brake_pads => 'Plaquettes de frein avant';

  @override
  String get comp_rear_brake_pads => 'Plaquettes de frein arrière';

  @override
  String get comp_front_brake_discs => 'Disques de frein avant';

  @override
  String get comp_rear_brake_discs => 'Disques de frein arrière';

  @override
  String get comp_timing_belt => 'Courroie de distribution';

  @override
  String get comp_auxiliary_belt => 'Courroie auxiliaire';

  @override
  String get comp_brake_fluid => 'Liquide de frein';

  @override
  String get comp_coolant => 'Liquide de refroidissement';

  @override
  String get comp_power_steering_fluid => 'Liquide de direction assistée';

  @override
  String get comp_spark_plugs => 'Bougies d\'allumage';

  @override
  String get comp_tires => 'Pneus';

  @override
  String get comp_battery => 'Batterie';

  @override
  String get comp_shock_absorbers => 'Amortisseurs';

  @override
  String get comp_steering_joints => 'Rotules de direction';

  @override
  String get comp_clutch_kit => 'Kit d\'embrayage';

  @override
  String get fuel_gasoline => 'Essence';

  @override
  String get fuel_diesel => 'Diesel';

  @override
  String get fuel_electric => 'Électrique';

  @override
  String get fuel_hybrid => 'Hybride';

  @override
  String get quickSuggestions => 'Suggestions rapides :';

  @override
  String get showLess => 'Afficher moins';

  @override
  String get showAllSuggestions => 'Afficher toutes les suggestions';

  @override
  String get registerRefuel => 'Enregistrer un plein';

  @override
  String get refuelDate => 'Date du plein';

  @override
  String get mileageAtPump => 'Kilométrage à la pompe';

  @override
  String get kWhCharged => 'kWh chargés';

  @override
  String get litersRefueled => 'Litres ravitaillés';

  @override
  String get totalAmountToPay => 'Montant total à payer';

  @override
  String get registerExpense => 'Enregistrer la dépense';

  @override
  String get noComponentsRegistered => 'Aucun composant enregistré';

  @override
  String get maintenanceCostOptional => 'Coût de l\'entretien (Optionnel)';

  @override
  String get pleaseSelectComponent => 'Veuillez sélectionner un composant';

  @override
  String get licensePlate => 'Plaque d\'immatriculation';

  @override
  String get licensePlateHint => 'Ex : 1234ABC';

  @override
  String get brandHint => 'Ex : Toyota';

  @override
  String get modelHint => 'Ex : Corolla';

  @override
  String get yearHint => 'Ex : 2018';

  @override
  String get fuelType => 'Type de Carburant';

  @override
  String get totalMoneyInverted => 'Argent Total Investi';

  @override
  String get deleteMaintenanceConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce dossier d\'entretien ?';

  @override
  String get appearance => 'Apparence';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get vehicleNotFound => 'Véhicule non trouvé';

  @override
  String get tripSimulator => 'Simulateur de Voyage';

  @override
  String get consumptionAndRefuels => 'Consommation & Pleins';

  @override
  String get healthDiagnosis => 'DIAGNOSTIC DE SANTÉ';

  @override
  String moreAlerts(Object count) {
    return '+ $count alertes supplémentaires...';
  }

  @override
  String get addRefuel => 'Ajouter un plein';

  @override
  String get refuelHistory => 'Historique des Pleins';

  @override
  String get noRefuelsYet => 'Pas encore de pleins.';

  @override
  String get globalAverageConsumption => 'Consommation Moyenne Globale';

  @override
  String get costPerKm => 'Coût par kilomètre';

  @override
  String get amount => 'Quantité';

  @override
  String get segmentConsumption => 'Consommation segment';

  @override
  String get unitPrice => 'Prix Unitaire';

  @override
  String get deleteRefuel => 'Supprimer le Plein';

  @override
  String get deleteRefuelConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce dossier de plein ? Les moyennes de consommation seront recalculées.';

  @override
  String get closeImage => 'Fermer l\'image';

  @override
  String get planNextAdventure => 'Planifiez votre prochaine aventure';

  @override
  String get analyzeImpact =>
      'Analysez l\'impact du kilométrage sur vos pièces';

  @override
  String get simulate => 'Simuler';

  @override
  String get filterCriticalOnly =>
      'Filtrer uniquement les avertissements critiques';

  @override
  String get highRiskTrip => 'Voyage à Haut Risque';

  @override
  String get requiresAttention => 'Nécessite une Attention';

  @override
  String get safeTrip => 'Voyage Sûr';

  @override
  String get critical => 'CRITIQUE';

  @override
  String componentsWillExceed(Object count) {
    return '$count composants dépasseront leur limite.';
  }

  @override
  String piecesNearMaintenance(Object count) {
    return 'Attention à $count pièces proches de leur entretien.';
  }

  @override
  String get everythingInOrder => 'Tout semble en ordre pour votre trajet.';

  @override
  String get selectVehicleFirst => 'Sélectionnez d\'abord un véhicule.';

  @override
  String get destinationOrTripName => 'Destination ou nom du voyage';

  @override
  String get totalKms => 'Kms totaux';

  @override
  String get goodHealth => 'Bon état';

  @override
  String get checkHealth => 'Révision requise';

  @override
  String get urgentHealth => 'Entretien urgent';

  @override
  String get login => 'Se connecter';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get enter => 'Entrer';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? Inscrivez-vous';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get current => 'Actuel';

  @override
  String get afterTrip => 'Après le voyage';
}

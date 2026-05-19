// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Personal Garage';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get noVehicles => 'No vehicles registered yet';

  @override
  String get addVehicle => 'Add Vehicle';

  @override
  String get editVehicle => 'Edit Vehicle';

  @override
  String get brand => 'Brand';

  @override
  String get model => 'Model';

  @override
  String get year => 'Year';

  @override
  String get currentMileage => 'Current Mileage';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get components => 'Components';

  @override
  String get history => 'History';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get addComponent => 'Add Component';

  @override
  String get editComponent => 'Edit Component';

  @override
  String get componentName => 'Component name';

  @override
  String get replacementInterval => 'Replacement interval (km)';

  @override
  String get lastChangeMileage => 'Mileage at last change';

  @override
  String get okStatus => 'OK';

  @override
  String get upcomingStatus => 'Upcoming';

  @override
  String get urgentStatus => 'Urgent';

  @override
  String remainingKm(Object km) {
    return '$km km remaining';
  }

  @override
  String overdueKm(Object km) {
    return 'Overdue by $km km!';
  }

  @override
  String get registerMaintenance => 'Log Maintenance';

  @override
  String get maintenanceDate => 'Maintenance Date';

  @override
  String get kmAtChange => 'Mileage at change';

  @override
  String get notes => 'Notes (Optional)';

  @override
  String get noHistory => 'No maintenance history';

  @override
  String get totalMaintenances => 'Total maintenances';

  @override
  String get frequentComponents => 'Most frequent components';

  @override
  String get noData => 'Not enough data';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get italian => 'Italian';

  @override
  String get german => 'German';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get delete => 'Delete';

  @override
  String get deleteVehicleConfirm =>
      'Are you sure you want to delete this vehicle? All its data and maintenance history will be wiped.';

  @override
  String get deleteComponentConfirm =>
      'Are you sure you want to delete this component and all its history?';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidNumber => 'Please enter a valid number';

  @override
  String get comp_engine_oil => 'Engine Oil';

  @override
  String get comp_oil_filter => 'Oil Filter';

  @override
  String get comp_air_filter => 'Air Filter';

  @override
  String get comp_cabin_filter => 'Cabin Filter (Pollen)';

  @override
  String get comp_fuel_filter => 'Fuel Filter';

  @override
  String get comp_front_brake_pads => 'Front Brake Pads';

  @override
  String get comp_rear_brake_pads => 'Rear Brake Pads';

  @override
  String get comp_front_brake_discs => 'Front Brake Discs';

  @override
  String get comp_rear_brake_discs => 'Rear Brake Discs';

  @override
  String get comp_timing_belt => 'Timing Belt';

  @override
  String get comp_auxiliary_belt => 'Auxiliary Belt (Serpentine)';

  @override
  String get comp_brake_fluid => 'Brake Fluid';

  @override
  String get comp_coolant => 'Coolant';

  @override
  String get comp_power_steering_fluid => 'Power Steering Fluid';

  @override
  String get comp_spark_plugs => 'Spark Plugs';

  @override
  String get comp_tires => 'Tires';

  @override
  String get comp_battery => 'Battery';

  @override
  String get comp_shock_absorbers => 'Shock Absorbers';

  @override
  String get comp_steering_joints => 'Steering Joints';

  @override
  String get comp_clutch_kit => 'Clutch Kit';

  @override
  String get fuel_gasoline => 'Gasoline';

  @override
  String get fuel_diesel => 'Diesel';

  @override
  String get fuel_electric => 'Electric';

  @override
  String get fuel_hybrid => 'Hybrid';

  @override
  String get quickSuggestions => 'Quick suggestions:';

  @override
  String get showLess => 'Show less';

  @override
  String get showAllSuggestions => 'Show all suggestions';

  @override
  String get registerRefuel => 'Log Refueling';

  @override
  String get refuelDate => 'Refueling date';

  @override
  String get mileageAtPump => 'Mileage at the pump';

  @override
  String get kWhCharged => 'kWh charged';

  @override
  String get litersRefueled => 'Liters refueled';

  @override
  String get totalAmountToPay => 'Total Amount to Pay';

  @override
  String get registerExpense => 'Log Expense';

  @override
  String get noComponentsRegistered => 'No components registered';

  @override
  String get maintenanceCostOptional => 'Maintenance Cost (Optional)';

  @override
  String get pleaseSelectComponent => 'Please select a component';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get licensePlateHint => 'Ex: 1234ABC';

  @override
  String get brandHint => 'Ex: Toyota';

  @override
  String get modelHint => 'Ex: Corolla';

  @override
  String get yearHint => 'Ex: 2018';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get totalMoneyInverted => 'Total Money Invested';

  @override
  String get deleteMaintenanceConfirm =>
      'Are you sure you want to delete this maintenance record?';

  @override
  String get appearance => 'Appearance';

  @override
  String get logout => 'Logout';

  @override
  String get vehicleNotFound => 'Vehicle not found';

  @override
  String get tripSimulator => 'Trip Simulator';

  @override
  String get consumptionAndRefuels => 'Consumption & Refuels';

  @override
  String get healthDiagnosis => 'HEALTH DIAGNOSIS';

  @override
  String moreAlerts(Object count) {
    return '+ $count more alerts...';
  }

  @override
  String get addRefuel => 'Add refuel';

  @override
  String get refuelHistory => 'Refuel History';

  @override
  String get noRefuelsYet => 'No refuels yet.';

  @override
  String get globalAverageConsumption => 'Global Average Consumption';

  @override
  String get costPerKm => 'Cost per kilometer';

  @override
  String get amount => 'Amount';

  @override
  String get segmentConsumption => 'Segment consumption';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get deleteRefuel => 'Delete Refuel';

  @override
  String get deleteRefuelConfirm =>
      'Are you sure you want to delete this refuel record? Average consumption will be recalculated.';

  @override
  String get closeImage => 'Close image';

  @override
  String get planNextAdventure => 'Plan your next adventure';

  @override
  String get analyzeImpact => 'Analyze the impact of mileage on your parts';

  @override
  String get simulate => 'Simulate';

  @override
  String get filterCriticalOnly => 'Filter critical warnings only';

  @override
  String get highRiskTrip => 'High Risk Trip';

  @override
  String get requiresAttention => 'Requires Attention';

  @override
  String get safeTrip => 'Safe Trip';

  @override
  String get critical => 'CRITICAL';

  @override
  String componentsWillExceed(Object count) {
    return '$count components will exceed their limit.';
  }

  @override
  String piecesNearMaintenance(Object count) {
    return 'Attention to $count parts near maintenance.';
  }

  @override
  String get everythingInOrder => 'Everything seems in order for your trip.';

  @override
  String get selectVehicleFirst => 'Select a vehicle first.';

  @override
  String get destinationOrTripName => 'Destination or trip name';

  @override
  String get totalKms => 'Total Kms';

  @override
  String get goodHealth => 'Good health';

  @override
  String get checkHealth => 'Check needed';

  @override
  String get urgentHealth => 'Urgent maintenance';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enter => 'Enter';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get current => 'Current';

  @override
  String get afterTrip => 'After trip';
}

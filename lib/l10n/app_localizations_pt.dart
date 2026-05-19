// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Oficina Pessoal';

  @override
  String get vehicles => 'Veículos';

  @override
  String get noVehicles => 'Nenhum veículo registrado';

  @override
  String get addVehicle => 'Adicionar Veículo';

  @override
  String get editVehicle => 'Editar Veículo';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modelo';

  @override
  String get year => 'Ano';

  @override
  String get currentMileage => 'Quilometragem Atual';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get dashboard => 'Painel de Controle';

  @override
  String get components => 'Componentes';

  @override
  String get history => 'Histórico';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get settings => 'Configurações';

  @override
  String get addComponent => 'Adicionar Componente';

  @override
  String get editComponent => 'Editar Componente';

  @override
  String get componentName => 'Nome do componente';

  @override
  String get replacementInterval => 'Intervalo de substituição (km)';

  @override
  String get lastChangeMileage => 'Km na última troca';

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
    return 'Atrasado em $km km!';
  }

  @override
  String get registerMaintenance => 'Registrar Manutenção';

  @override
  String get maintenanceDate => 'Data da manutenção';

  @override
  String get kmAtChange => 'Quilometragem na troca';

  @override
  String get notes => 'Notas (Opcional)';

  @override
  String get noHistory => 'Sem histórico de manutenção';

  @override
  String get totalMaintenances => 'Total de manutenções';

  @override
  String get frequentComponents => 'Componentes mais frequentes';

  @override
  String get noData => 'Dados insuficientes';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Espanhol';

  @override
  String get english => 'Inglês';

  @override
  String get french => 'Francês';

  @override
  String get portuguese => 'Português';

  @override
  String get italian => 'Italiano';

  @override
  String get german => 'Alemão';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteVehicleConfirm =>
      'Tem certeza de que deseja excluir este veículo? Todos os seus dados e o histórico de manutenção serão apagados.';

  @override
  String get deleteComponentConfirm =>
      'Tem certeza de que deseja excluir este componente e todo o seu histórico?';

  @override
  String get requiredField => 'Este campo é obrigatório';

  @override
  String get invalidNumber => 'Insira um número válido';

  @override
  String get comp_engine_oil => 'Óleo do motor';

  @override
  String get comp_oil_filter => 'Filtro de óleo';

  @override
  String get comp_air_filter => 'Filtro de ar';

  @override
  String get comp_cabin_filter => 'Filtro de cabine (Pólen)';

  @override
  String get comp_fuel_filter => 'Filtro de combustível';

  @override
  String get comp_front_brake_pads => 'Pastilhas de freio dianteiras';

  @override
  String get comp_rear_brake_pads => 'Pastilhas de freio traseiras';

  @override
  String get comp_front_brake_discs => 'Discos de freio dianteiros';

  @override
  String get comp_rear_brake_discs => 'Discos de freio traseiros';

  @override
  String get comp_timing_belt => 'Correia de distribuição';

  @override
  String get comp_auxiliary_belt => 'Correia auxiliar';

  @override
  String get comp_brake_fluid => 'Fluido de freio';

  @override
  String get comp_coolant => 'Líquido de arrefecimento';

  @override
  String get comp_power_steering_fluid => 'Fluido de direção hidráulica';

  @override
  String get comp_spark_plugs => 'Velas de ignição';

  @override
  String get comp_tires => 'Pneus';

  @override
  String get comp_battery => 'Bateria';

  @override
  String get comp_shock_absorbers => 'Amortecedores';

  @override
  String get comp_steering_joints => 'Juntas de direção';

  @override
  String get comp_clutch_kit => 'Kit de embreagem';

  @override
  String get fuel_gasoline => 'Gasolina';

  @override
  String get fuel_diesel => 'Diesel';

  @override
  String get fuel_electric => 'Elétrico';

  @override
  String get fuel_hybrid => 'Híbrido';

  @override
  String get quickSuggestions => 'Sugestões rápidas:';

  @override
  String get showLess => 'Mostrar menos';

  @override
  String get showAllSuggestions => 'Mostrar todas as sugestões';

  @override
  String get registerRefuel => 'Registrar abastecimento';

  @override
  String get refuelDate => 'Data do abastecimento';

  @override
  String get mileageAtPump => 'Quilometragem na bomba';

  @override
  String get kWhCharged => 'kWh carregados';

  @override
  String get litersRefueled => 'Litros abastecidos';

  @override
  String get totalAmountToPay => 'Valor total a pagar';

  @override
  String get registerExpense => 'Registrar gasto';

  @override
  String get noComponentsRegistered => 'Nenhum componente registrado';

  @override
  String get maintenanceCostOptional => 'Custo da manutenção (Opcional)';

  @override
  String get pleaseSelectComponent => 'Por favor, selecione um componente';

  @override
  String get licensePlate => 'Placa';

  @override
  String get licensePlateHint => 'Ex: 1234ABC';

  @override
  String get brandHint => 'Ex: Toyota';

  @override
  String get modelHint => 'Ex: Corolla';

  @override
  String get yearHint => 'Ex: 2018';

  @override
  String get fuelType => 'Tipo de Combustível';

  @override
  String get totalMoneyInverted => 'Dinheiro Total Investido';

  @override
  String get deleteMaintenanceConfirm =>
      'Tem certeza de que deseja excluir este registro de manutenção?';

  @override
  String get appearance => 'Aparência';

  @override
  String get logout => 'Sair';

  @override
  String get vehicleNotFound => 'Veículo não encontrado';

  @override
  String get tripSimulator => 'Simulador de Viagem';

  @override
  String get consumptionAndRefuels => 'Consumo & Reabastecimentos';

  @override
  String get healthDiagnosis => 'DIAGNÓSTICO DE SAÚDE';

  @override
  String moreAlerts(Object count) {
    return '+ $count mais alertas...';
  }

  @override
  String get addRefuel => 'Adicionar reabastecimento';

  @override
  String get refuelHistory => 'Histórico de Reabastecimentos';

  @override
  String get noRefuelsYet => 'Ainda não há reabastecimentos.';

  @override
  String get globalAverageConsumption => 'Consumo Médio Global';

  @override
  String get costPerKm => 'Custo por quilômetro';

  @override
  String get amount => 'Quantidade';

  @override
  String get segmentConsumption => 'Consumo trecho';

  @override
  String get unitPrice => 'Preço Unitário';

  @override
  String get deleteRefuel => 'Excluir Reabastecimento';

  @override
  String get deleteRefuelConfirm =>
      'Tem certeza de que deseja excluir este registro de reabastecimento? As médias de consumo serão recalculadas.';

  @override
  String get closeImage => 'Fechar imagem';

  @override
  String get planNextAdventure => 'Planeje sua próxima aventura';

  @override
  String get analyzeImpact =>
      'Analise o impacto da quilometragem em suas peças';

  @override
  String get simulate => 'Simular';

  @override
  String get filterCriticalOnly => 'Filtrar apenas avisos críticos';

  @override
  String get highRiskTrip => 'Viagem de Alto Risco';

  @override
  String get requiresAttention => 'Requer Atenção';

  @override
  String get safeTrip => 'Viagem Segura';

  @override
  String get critical => 'CRÍTICO';

  @override
  String componentsWillExceed(Object count) {
    return 'Detectados $count componentes que excederão seu limite.';
  }

  @override
  String piecesNearMaintenance(Object count) {
    return 'Atenção a $count peças próximas à sua manutenção.';
  }

  @override
  String get everythingInOrder =>
      'Tudo parece estar em ordem para o seu trajeto.';

  @override
  String get selectVehicleFirst => 'Selecione um veículo primeiro.';

  @override
  String get destinationOrTripName => 'Destino ou nome da viagem';

  @override
  String get totalKms => 'Kms totais';

  @override
  String get goodHealth => 'Bom estado';

  @override
  String get checkHealth => 'Revisão necessária';

  @override
  String get urgentHealth => 'Manutenção urgente';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Registrar';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get enter => 'Entrar';

  @override
  String get dontHaveAccount => 'Não tem uma conta? Registre-se';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? Entre';

  @override
  String get current => 'Atual';

  @override
  String get afterTrip => 'Pós-viagem';
}

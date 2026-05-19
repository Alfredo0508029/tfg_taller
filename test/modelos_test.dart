import 'package:flutter_test/flutter_test.dart';
import 'package:tfg_taller/data/modelos/componente.dart';
import 'package:tfg_taller/data/modelos/vehiculo.dart';

void main() {
  group('Componente Model Tests', () {
    test('proximoCambioKm se calcula correctamente', () {
      final componente = Componente(
        vehiculoMatricula: '1234ABC',
        nombre: 'Aceite de Motor',
        intervaloKm: 15000,
        ultimoCambioKm: 50000,
      );

      // Si se cambió a los 50.000 y dura 15.000, el próximo es a los 65.000
      expect(componente.proximoCambioKm, 65000);
    });

    test(
      'kmRestantes se calcula correctamente cuando el componente está bien',
      () {
        final componente = Componente(
          vehiculoMatricula: '1234ABC',
          nombre: 'Aceite de Motor',
          intervaloKm: 10000,
          ultimoCambioKm: 20000, // Próximo cambio a los 30.000
        );

        final kmVehiculoActual = 25000;

        // 30000 - 25000 = 5000 restantes
        expect(componente.kmRestantes(kmVehiculoActual), 5000);
      },
    );

    test('kmRestantes es negativo cuando el componente está atrasado', () {
      final componente = Componente(
        vehiculoMatricula: '1234ABC',
        nombre: 'Filtro de Aire',
        intervaloKm: 20000,
        ultimoCambioKm: 10000, // Próximo cambio a los 30.000
      );

      final kmVehiculoActual = 35000;

      // 30000 - 35000 = -5000 restantes (atrasado por 5000km)
      expect(componente.kmRestantes(kmVehiculoActual), -5000);
    });
  });

  group('Vehiculo Model Tests', () {
    test('nombreCompleto se formatear correctamente', () {
      final vehiculo = Vehiculo(
        marca: 'Toyota',
        modelo: 'Corolla',
        anio: 2020,
        kilometrajeActual: 50000,
        tipoCarburante: 'gasolina',
      );

      expect(vehiculo.nombreCompleto, 'Toyota Corolla (2020)');
    });

    test('serialización aMapa funciona', () {
      final vehiculo = Vehiculo(
        matricula: '1234ABC',
        marca: 'Ford',
        modelo: 'Focus',
        anio: 2018,
        kilometrajeActual: 120000,
        tipoCarburante: 'gasolina',
      );

      final mapa = vehiculo.aSupabase();

      expect(mapa['matricula'], '1234ABC');
      expect(mapa['marca'], 'Ford');
      expect(mapa['modelo'], 'Focus');
      expect(mapa['anio'], 2018);
      expect(mapa['kilometraje_actual'], 120000);
    });
  });
}

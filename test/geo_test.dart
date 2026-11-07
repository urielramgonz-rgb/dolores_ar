import 'package:flutter_test/flutter_test.dart';
import 'package:dolores_ar/dominio/geo.dart';

import 'ayudas_geo.dart';

void main() {
  group('distancia Haversine', () {
    test(
      'un grado de latitud son 111.2 km',
      () => expect(
        distanciaMetros(const Coordenada(0, 0), const Coordenada(1, 0)),
        closeTo(111195, 5),
      ),
    );
    test(
      'mismo punto es cero',
      () => expect(distanciaMetros(origen, origen), 0),
    );
    test('es simétrica', () {
      final b = desplazar(origen, norte: 300, este: 400);
      expect(
        distanciaMetros(origen, b),
        closeTo(distanciaMetros(b, origen), .001),
      );
    });
    test(
      'triángulo 3-4-5',
      () => expect(
        distanciaMetros(origen, desplazar(origen, norte: 300, este: 400)),
        closeTo(500, 1),
      ),
    );
  });
  group('rumbo y ángulos', () {
    test('rumbos cardinales', () {
      expect(
        rumboGrados(origen, desplazar(origen, norte: 100)),
        closeTo(0, .01),
      );
      expect(
        rumboGrados(origen, desplazar(origen, este: 100)),
        closeTo(90, .01),
      );
      expect(
        rumboGrados(origen, desplazar(origen, norte: -100)),
        closeTo(180, .01),
      );
      expect(
        rumboGrados(origen, desplazar(origen, este: -100)),
        closeTo(270, .01),
      );
    });
    test('normaliza y resuelve cruce norte', () {
      expect(normalizar360(-90), 270);
      expect(normalizar360(725), 5);
      expect(diferenciaAngular(10, 350), 20);
      expect(diferenciaAngular(350, 10), -20);
    });
    test(
      'suaviza circularmente',
      () => expect(suavizarAngulo(350, 10, alfa: .5), closeTo(0, 1e-9)),
    );
    test('nombre cardinal', () => expect(nombreCardinal(350), 'N'));
  });
  group('campo visual', () {
    test('centro, bordes y fuera del FOV', () {
      expect(posicionHorizontal(0), .5);
      expect(posicionHorizontal(30), 1);
      expect(posicionHorizontal(-30), 0);
      expect(posicionHorizontal(31), isNull);
    });
    test('formatea distancia', () {
      expect(formatearDistancia(85.4), '85 m');
      expect(formatearDistancia(1260), '1.3 km');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:dolores_ar/dominio/pasaporte.dart';

import 'ayudas_geo.dart';

void main() {
  final plaza = lugarEn('plaza', origen);
  test('solo sella a menos de 40m inclusive', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 41), false);
    expect(p.registrarSiCerca(plaza, 40), true);
    expect(p.registrarSiCerca(plaza, 20), false);
    expect(p.total, 1);
  });
  test('progreso seguro cuando vacío', () {
    expect(Pasaporte().progreso(0), 0);
    expect((Pasaporte()..registrarSiCerca(plaza, 10)).progreso(4), .25);
  });
}

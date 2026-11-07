import 'package:flutter_test/flutter_test.dart';
import 'package:dolores_ar/dominio/motor_ar.dart';

import 'ayudas_geo.dart';

void main() {
  final frente = lugarEn('frente', desplazar(origen, norte: 100));
  final derecha = lugarEn('derecha', desplazar(origen, este: 100));
  test('lugar adelante queda centrado', () {
    final r = calcularVisibles(usuario: origen, rumbo: 0, lugares: [frente]);
    expect(r.single.x, closeTo(.5, .01));
    expect(r.single.distancia, closeTo(100, 1));
  });
  test('filtro de rumbo y giro', () {
    expect(
      calcularVisibles(usuario: origen, rumbo: 0, lugares: [derecha]),
      isEmpty,
    );
    expect(
      calcularVisibles(usuario: origen, rumbo: 90, lugares: [derecha]).single.x,
      closeTo(.5, .01),
    );
  });
  test('cruce norte mantiene dirección derecha', () {
    final casi = lugarEn('casi', desplazar(origen, norte: 100, este: 8.7));
    expect(
      calcularVisibles(usuario: origen, rumbo: 350, lugares: [casi]).single.x,
      greaterThan(.5),
    );
  });
  test(
    'radio máximo filtra lejanos',
    () => expect(
      calcularVisibles(
        usuario: origen,
        rumbo: 0,
        lugares: [lugarEn('lejos', desplazar(origen, norte: 5000))],
      ),
      isEmpty,
    ),
  );
}

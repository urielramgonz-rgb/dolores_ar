import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:dolores_ar/dominio/excepciones.dart';
import 'package:dolores_ar/dominio/fuentes.dart';
import 'package:dolores_ar/dominio/geo.dart';
import 'package:dolores_ar/dominio/pasaporte.dart';
import 'package:dolores_ar/presentacion/ar_viewmodel.dart';

import 'ayudas_geo.dart';

class PosicionFalsa implements FuentePosicion {
  final c = StreamController<Coordenada>.broadcast();
  @override
  Stream<Coordenada> get posiciones => c.stream;
}

class BrujulaFalsa implements FuenteBrujula {
  final c = StreamController<double>.broadcast();
  @override
  Stream<double> get rumbos => c.stream;
}

void main() {
  late PosicionFalsa gps;
  late BrujulaFalsa compass;
  late Pasaporte pass;
  ArViewModel crear() {
    gps = PosicionFalsa();
    compass = BrujulaFalsa();
    pass = Pasaporte();
    final vm = ArViewModel(
      posicion: gps,
      brujula: compass,
      lugares: [lugarEn('sitio', desplazar(origen, norte: 20))],
      pasaporte: pass,
    )..iniciar();
    return vm;
  }

  test('espera ambos sensores, actualiza y gana sello', () async {
    final vm = crear();
    expect(vm.esperando, true);
    gps.c.add(origen);
    compass.c.add(0);
    await pumpEventQueue();
    expect(vm.esperando, false);
    expect(vm.visibles, hasLength(1));
    expect(vm.consumirSello()?.id, 'sitio');
    expect(pass.total, 1);
    vm.dispose();
    await gps.c.close();
    await compass.c.close();
  });
  test('muestra error amable y oculta detalles inesperados', () async {
    final vm = crear();
    gps.c.addError(const PermisoUbicacionException());
    await pumpEventQueue();
    expect(vm.error, contains('permiso'));
    compass.c.addError(StateError('detalle interno'));
    await pumpEventQueue();
    expect(vm.error, contains('inesperado'));
    expect(vm.error, isNot(contains('interno')));
    vm.dispose();
    await gps.c.close();
    await compass.c.close();
  });
}

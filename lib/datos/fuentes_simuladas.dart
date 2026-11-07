import 'dart:async';

import '../dominio/fuentes.dart';
import '../dominio/geo.dart';

class PosicionSimulada implements FuentePosicion {
  final Coordenada punto;
  PosicionSimulada(this.punto);
  @override
  Stream<Coordenada> get posiciones => Stream.value(punto);
}

class BrujulaSimulada implements FuenteBrujula {
  final _controlador = StreamController<double>.broadcast();
  double _ultimo = 0;
  @override
  Stream<double> get rumbos async* {
    yield _ultimo;
    yield* _controlador.stream;
  }

  void girar(double grados) {
    _ultimo = grados;
    _controlador.add(grados);
  }

  void cerrar() => _controlador.close();
}

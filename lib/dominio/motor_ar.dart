import 'geo.dart';
import 'lugar.dart';

class LugarVisible {
  final Lugar lugar;
  final double distancia, x, profundidad, escala;
  const LugarVisible(
    this.lugar,
    this.distancia,
    this.x,
    this.profundidad,
    this.escala,
  );
}

List<LugarVisible> calcularVisibles({
  required Coordenada usuario,
  required double rumbo,
  required List<Lugar> lugares,
  double campoVision = 60,
  double radioMax = 2000,
}) {
  final salida = <LugarVisible>[];
  for (final l in lugares) {
    final d = distanciaMetros(usuario, l.coordenada);
    if (d > radioMax) continue;
    final x = posicionHorizontal(
      diferenciaAngular(rumboGrados(usuario, l.coordenada), rumbo),
      campoVision: campoVision,
    );
    if (x == null) continue;
    final depth = (d / radioMax).clamp(0.0, 1.0).toDouble();
    salida.add(LugarVisible(l, d, x, depth, 1.2 - 0.6 * depth));
  }
  salida.sort((a, b) => b.distancia.compareTo(a.distancia));
  return salida;
}

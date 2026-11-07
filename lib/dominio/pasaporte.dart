import 'lugar.dart';

class Pasaporte {
  static const double radioSello = 40;
  final Set<String> _visitados = {};
  bool registrarSiCerca(Lugar lugar, double distanciaMetros) =>
      distanciaMetros <= radioSello && _visitados.add(lugar.id);
  bool visitado(String id) => _visitados.contains(id);
  int get total => _visitados.length;
  double progreso(int totalLugares) =>
      totalLugares == 0 ? 0 : total / totalLugares;
}

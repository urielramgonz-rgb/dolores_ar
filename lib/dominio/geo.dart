import 'dart:math' as math;

class Coordenada {
  final double lat;
  final double lon;
  const Coordenada(this.lat, this.lon);
  @override
  String toString() => '(${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)})';
}

const double _radioTierra = 6371000;
double _rad(double g) => g * math.pi / 180;
double _grados(double r) => r * 180 / math.pi;

double distanciaMetros(Coordenada a, Coordenada b) {
  final dLat = _rad(b.lat - a.lat), dLon = _rad(b.lon - a.lon);
  final h =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(a.lat)) *
          math.cos(_rad(b.lat)) *
          math.pow(math.sin(dLon / 2), 2);
  return 2 * _radioTierra * math.asin(math.sqrt(h.clamp(0.0, 1.0).toDouble()));
}

double rumboGrados(Coordenada a, Coordenada b) {
  final dLon = _rad(b.lon - a.lon), lat1 = _rad(a.lat), lat2 = _rad(b.lat);
  return normalizar360(
    _grados(
      math.atan2(
        math.sin(dLon) * math.cos(lat2),
        math.cos(lat1) * math.sin(lat2) -
            math.sin(lat1) * math.cos(lat2) * math.cos(dLon),
      ),
    ),
  );
}

double normalizar360(double g) => ((g % 360) + 360) % 360;
double diferenciaAngular(double objetivo, double actual) {
  var d = normalizar360(objetivo - actual);
  if (d > 180) d -= 360;
  return d;
}

double suavizarAngulo(double anterior, double nuevo, {double alfa = 0.2}) =>
    normalizar360(anterior + alfa * diferenciaAngular(nuevo, anterior));
double? posicionHorizontal(double diferencia, {double campoVision = 60}) =>
    diferencia.abs() > campoVision / 2 ? null : 0.5 + diferencia / campoVision;
String formatearDistancia(double metros) => metros < 1000
    ? '${metros.round()} m'
    : '${(metros / 1000).toStringAsFixed(1)} km';
String nombreCardinal(double grados) {
  const puntos = ['N', 'NE', 'E', 'SE', 'S', 'SO', 'O', 'NO'];
  return puntos[((normalizar360(grados) + 22.5) ~/ 45) % 8];
}

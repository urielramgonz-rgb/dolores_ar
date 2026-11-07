abstract class ErrorDeApp implements Exception {
  const ErrorDeApp();
}

class PermisoUbicacionException extends ErrorDeApp {
  const PermisoUbicacionException();
  @override
  String toString() =>
      'Necesito el permiso de ubicación para mostrarte lugares cercanos. Actívalo en Ajustes.';
}

class UbicacionApagadaException extends ErrorDeApp {
  const UbicacionApagadaException();
  @override
  String toString() =>
      'El GPS está apagado. Actívalo para usar la realidad aumentada.';
}

class SinBrujulaException extends ErrorDeApp {
  const SinBrujulaException();
  @override
  String toString() => 'Este dispositivo no tiene brújula. Usa el modo demo.';
}

String mensajeSeguro(Object error) => error is ErrorDeApp
    ? error.toString()
    : 'Ocurrió un error inesperado. Intenta de nuevo.';

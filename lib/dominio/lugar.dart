import 'geo.dart';

enum Categoria { historia, museo, plaza, musica, gastronomia }

class Lugar {
  final String id, nombre, emoji, descripcion, datoCurioso;
  final Categoria categoria;
  final Coordenada coordenada;
  const Lugar({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.categoria,
    required this.descripcion,
    required this.datoCurioso,
    required this.coordenada,
  });
}

import 'geo.dart';
import 'lugar.dart';

const catalogoDolores = <Lugar>[
  Lugar(
    id: 'plaza',
    nombre: 'Jardín Principal',
    emoji: '🌳',
    categoria: Categoria.plaza,
    descripcion: 'El corazón de Dolores Hidalgo: kiosco, árboles y vida local.',
    datoCurioso:
        'Cada tarde se reúnen familias y visitantes alrededor del jardín.',
    coordenada: Coordenada(21.15610, -100.93180),
  ),
  Lugar(
    id: 'parroquia',
    nombre: 'Parroquia de Nuestra Señora de los Dolores',
    emoji: '⛪',
    categoria: Categoria.historia,
    descripcion: 'Templo donde Miguel Hidalgo convocó al pueblo en 1810.',
    datoCurioso: 'Dolores Hidalgo es conocida como la Cuna de la Independencia Nacional.',
    coordenada: Coordenada(21.15650, -100.93150),
  ),
  Lugar(
    id: 'casa_visita',
    nombre: 'Museo Casa de Visita',
    emoji: '🏛️',
    categoria: Categoria.museo,
    descripcion: 'Casa histórica dedicada a la vida de Miguel Hidalgo.',
    datoCurioso:
        'Conserva memoria de los primeros años del movimiento independentista.',
    coordenada: Coordenada(21.15590, -100.93085),
  ),
  Lugar(
    id: 'museo_independencia',
    nombre: 'Museo de la Independencia Nacional',
    emoji: '📜',
    categoria: Categoria.museo,
    descripcion:
        'Documentos y objetos narran el inicio de la lucha de Independencia.',
    datoCurioso: 'El museo ocupa un edificio histórico del centro.',
    coordenada: Coordenada(21.15700, -100.93230),
  ),
  Lugar(
    id: 'museo_jaj',
    nombre: 'Museo José Alfredo Jiménez',
    emoji: '🎼',
    categoria: Categoria.musica,
    descripcion: 'Homenaje al cantautor dolorense autor de El Rey.',
    datoCurioso: 'José Alfredo Jiménez nació en Dolores Hidalgo en 1926.',
    coordenada: Coordenada(21.15520, -100.93260),
  ),
  Lugar(
    id: 'nieves',
    nombre: 'Nieves del Jardín',
    emoji: '🍦',
    categoria: Categoria.gastronomia,
    descripcion: 'Puestos de nieves con sabores tradicionales y sorprendentes.',
    datoCurioso: 'Probar una nieve atrevida es parte de la visita.',
    coordenada: Coordenada(21.15605, -100.93165),
  ),
  Lugar(
    id: 'tumba_jaj',
    nombre: 'Tumba de José Alfredo Jiménez',
    emoji: '🌹',
    categoria: Categoria.musica,
    descripcion:
        'Lugar de descanso del compositor, visitado por sus admiradores.',
    datoCurioso: 'Su tumba monumental está en el cementerio municipal.',
    coordenada: Coordenada(21.14980, -100.92700),
  ),
];

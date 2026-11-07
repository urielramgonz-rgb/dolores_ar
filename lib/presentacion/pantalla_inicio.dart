import 'package:flutter/material.dart';

import '../datos/fuentes_reales.dart';
import '../datos/fuentes_simuladas.dart';
import '../dominio/catalogo.dart';
import '../dominio/geo.dart';
import '../dominio/pasaporte.dart';
import 'ar_viewmodel.dart';
import 'pantalla_ar.dart';
import 'pantalla_modelo3d.dart';

class PantallaInicio extends StatelessWidget {
  final Pasaporte pasaporte;
  const PantallaInicio({super.key, required this.pasaporte});
  void _abrirReal(BuildContext c) => Navigator.push(
    c,
    MaterialPageRoute<void>(
      builder: (_) => PantallaAr(
        crearVm: () => ArViewModel(
          posicion: PosicionGps(),
          brujula: BrujulaReal(),
          lugares: catalogoDolores,
          pasaporte: pasaporte,
        ),
      ),
    ),
  );
  void _abrirDemo(BuildContext c) {
    final b = BrujulaSimulada();
    Navigator.push(
      c,
      MaterialPageRoute<void>(
        builder: (_) => PantallaAr(
          crearVm: () => ArViewModel(
            posicion: PosicionSimulada(const Coordenada(21.15600, -100.93175)),
            brujula: b,
            lugares: catalogoDolores,
            pasaporte: pasaporte,
          ),
          controlesDemo: _DemoSlider(brujula: b),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Dolores AR'),
      actions: [
        IconButton(
          tooltip: 'Aviso de seguridad',
          icon: const Icon(Icons.info_outline),
          onPressed: () => _seguridad(context),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Descubre Dolores Hidalgo',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text('Apunta tu teléfono y conoce la historia que te rodea.'),
        const SizedBox(height: 18),
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'Camina con cuidado. Mira a tu alrededor y no cruces la calle viendo el teléfono. Tu ubicación solo se usa en el dispositivo mientras la app está abierta.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _abrirReal(context),
          icon: const Icon(Icons.explore),
          label: const Text('Explorar con GPS real'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _abrirDemo(context),
          icon: const Icon(Icons.school),
          label: const Text('Modo demo (salón de clases)'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const PantallaModelo3D()),
          ),
          icon: const Icon(Icons.view_in_ar),
          label: const Text('Modelo 3D en tu espacio'),
        ),
        const SizedBox(height: 20),
        Text(
          'Pasaporte turístico · ${pasaporte.total}/${catalogoDolores.length} sellos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        LinearProgressIndicator(
          value: pasaporte.progreso(catalogoDolores.length),
        ),
        const SizedBox(height: 12),
        Text(
          'Lugares del recorrido',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        for (final l in catalogoDolores)
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(l.nombre),
            trailing: Icon(
              pasaporte.visitado(l.id) ? Icons.verified : Icons.circle_outlined,
            ),
          ),
      ],
    ),
  );
  void _seguridad(BuildContext c) => showDialog<void>(
    context: c,
    builder: (_) => AlertDialog(
      title: const Text('Visita con cuidado'),
      content: const Text(
        'Mira a tu alrededor, cuida tu paso y no cruces la calle viendo el teléfono. La lista de lugares funciona sin cámara.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}

class _DemoSlider extends StatefulWidget {
  final BrujulaSimulada brujula;
  const _DemoSlider({required this.brujula});
  @override
  State<_DemoSlider> createState() => _DemoSliderState();
}

class _DemoSliderState extends State<_DemoSlider> {
  double grados = 0;
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black54,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        const Text('Gira:', style: TextStyle(color: Colors.white)),
        Expanded(
          child: Slider(
            min: 0,
            max: 359,
            value: grados,
            onChanged: (g) {
              setState(() => grados = g);
              widget.brujula.girar(g);
            },
          ),
        ),
        Text('${grados.round()}°', style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}

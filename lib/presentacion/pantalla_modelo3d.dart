import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class PantallaModelo3D extends StatelessWidget {
  final Widget? visor;
  const PantallaModelo3D({super.key, this.visor});
  static const modelo =
      'https://modelviewer.dev/shared-assets/models/Astronaut.glb';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Modelo 3D en tu espacio')),
    body:
        visor ??
        const ModelViewer(
          src: modelo,
          alt: 'Modelo 3D de práctica',
          ar: true,
          arModes: ['scene-viewer', 'webxr', 'quick-look'],
          autoRotate: true,
          cameraControls: true,
        ),
  );
}

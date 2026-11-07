import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FondoCamara extends StatefulWidget {
  const FondoCamara({super.key});
  @override
  State<FondoCamara> createState() => _FondoCamaraState();
}

class _FondoCamaraState extends State<FondoCamara> {
  CameraController? _controller;
  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    try {
      final cams = await availableCameras();
      final camera = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );
      final c = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _controller?.value.isInitialized == true
      ? SizedBox.expand(child: CameraPreview(_controller!))
      : const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff273c50), Color(0xff91a7a4), Color(0xffd2b889)],
            ),
          ),
          child: Center(
            child: Icon(Icons.landscape, color: Colors.white54, size: 110),
          ),
        );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dominio/pasaporte.dart';
import 'presentacion/pantalla_inicio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MaterialApp(
      title: 'Dolores AR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: PantallaInicio(pasaporte: Pasaporte()),
    ),
  );
}

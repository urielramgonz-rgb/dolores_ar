import 'dart:async';
import 'dart:io';

import 'package:dolores_ar/dominio/fuentes.dart';
import 'package:dolores_ar/dominio/geo.dart';
import 'package:dolores_ar/dominio/lugar.dart';
import 'package:dolores_ar/dominio/pasaporte.dart';
import 'package:dolores_ar/presentacion/ar_viewmodel.dart';
import 'package:dolores_ar/presentacion/pantalla_ar.dart';
import 'package:dolores_ar/presentacion/pantalla_inicio.dart';
import 'package:dolores_ar/presentacion/pantalla_modelo3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final _theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  useMaterial3: true,
);

class _Gps implements FuentePosicion {
  @override
  Stream<Coordenada> get posiciones =>
      Stream.value(const Coordenada(21.1561, -100.9318));
}

class _Compass implements FuenteBrujula {
  @override
  Stream<double> get rumbos => Stream.value(0);
}

void main() {
  const sitio = Lugar(
    id: 'parroquia',
    nombre: 'Parroquia',
    emoji: '⛪',
    categoria: Categoria.historia,
    descripcion: 'Templo histórico de Dolores Hidalgo.',
    datoCurioso: 'Aquí comenzó una parte importante de la Independencia.',
    coordenada: Coordenada(21.1570, -100.9318),
  );

  setUp(() => TestWidgetsFlutterBinding.ensureInitialized());

  setUpAll(() async {
    final font = File('test/fonts/roboto-regular.ttf').readAsBytesSync();
    final loader = FontLoader('Roboto')
      ..addFont(Future.value(ByteData.sublistView(font)));
    await loader.load();
    final iconFont = File('test/fonts/material-icons.otf').readAsBytesSync();
    final iconLoader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.sublistView(iconFont)));
    await iconLoader.load();
  });

  testWidgets('evidencia de inicio y pasaporte', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme,
        home: PantallaInicio(pasaporte: Pasaporte()),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/01_inicio.png'),
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('evidencia del aviso de seguridad', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme,
        home: PantallaInicio(pasaporte: Pasaporte()),
      ),
    );
    await tester.tap(find.byTooltip('Aviso de seguridad'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/06_seguridad.png'),
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('evidencia de realidad aumentada y detalle', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    final pasaporte = Pasaporte();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme,
        home: PantallaAr(
          crearVm: () => ArViewModel(
            posicion: _Gps(),
            brujula: _Compass(),
            lugares: const [sitio],
            pasaporte: pasaporte,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/02_ar.png'),
    );
    await tester.tap(find.textContaining('Parroquia'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/03_detalle.png'),
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('evidencia de modo demo', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme,
        home: PantallaInicio(pasaporte: Pasaporte()),
      ),
    );
    await tester.tap(find.text('Modo demo (salón de clases)'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/04_demo.png'),
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('evidencia de pantalla del modelo 3D', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme,
        home: const PantallaModelo3D(
          visor: ColoredBox(
            color: Color(0xff273c50),
            child: Center(
              child: Text(
                'Modelo 3D · Astronaut.glb\nAR disponible',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/05_modelo_3d.png'),
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}

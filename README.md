# Dolores AR

App turística para explorar Dolores Hidalgo con realidad aumentada por ubicación, GPS, brújula, cámara, modo demo, pasaporte de visitas y una pantalla de modelo 3D.

## Ejecutar

```sh
flutter pub get
flutter run
```

Usa un teléfono Android o iPhone para probar GPS, brújula y cámara. El modo demo funciona sin esos sensores. Las coordenadas del catálogo son aproximadas y deben calibrarse en campo.

## Pasos implementados y evidencia

Las capturas PNG se generaron desde pruebas de widgets en `test/pantallas_test.dart`, con viewport de teléfono (390 × 844). Las pruebas de dominio cubren los cálculos que no aparecen directamente en una captura de interfaz.

| Paso del manual | Implementación y verificación | Evidencia |
| --- | --- | --- |
| **Ronda 0 · Preparar el taller** | Paquetes de cámara, ubicación, brújula y visor 3D; permisos Android/iOS; orientación vertical. | [Inicio y catálogo](test/screenshots/01_inicio.png) |
| **Ronda 1 · Distancia Haversine** | `geo.dart`; distancia entre coordenadas, simetría y triángulo 3-4-5. | [Vista AR con distancia](test/screenshots/02_ar.png) · `test/geo_test.dart` |
| **Ronda 2 · Rumbo y ángulos** | Rumbos cardinales, cruce 359°/0°, normalización y filtro circular. | [Etiquetas según el rumbo](test/screenshots/04_demo.png) · `test/geo_test.dart` |
| **Ronda 3 · Campo de visión** | Posición horizontal, campo configurable, escala y distancia legible. | [Vista AR](test/screenshots/02_ar.png) · `test/geo_test.dart` |
| **Ronda 4 · Motor AR** | Visibilidad por rumbo y radio, posición en pantalla, profundidad y orden de etiquetas. | [Modo demo con lugares visibles](test/screenshots/04_demo.png) · `test/motor_ar_test.dart` |
| **Ronda 5 · Pasaporte turístico** | Sellos al llegar a 40 m, progreso y una sola notificación por lugar. | [Progreso del pasaporte](test/screenshots/01_inicio.png) · `test/pasaporte_test.dart` |
| **Ronda 6 · Fuentes y ViewModel** | Contratos para GPS y brújula, sensores simulados, suavizado, errores seguros y cancelación de suscripciones. | [Pantalla AR del demo](test/screenshots/04_demo.png) · `test/ar_viewmodel_test.dart` |
| **Ronda 7 · Pantalla AR** | Fondo de cámara con degradado de respaldo, etiquetas tocables, detalle y controles demo. | [Vista AR](test/screenshots/02_ar.png) · [Detalle del lugar](test/screenshots/03_detalle.png) |
| **Ronda 8 · Modelo 3D** | `model_viewer_plus` con ARCore/Scene Viewer, WebXR y Quick Look. | [Pantalla del visor](test/screenshots/05_modelo_3d.png) |
| **Ronda 9 · Campo, privacidad y seguridad** | Diagnóstico de coordenadas, uso local de ubicación, permisos mientras la app está abierta, aviso para caminar con cuidado y catálogo disponible sin cámara. | [Aviso de seguridad](test/screenshots/06_seguridad.png) |

La captura del visor 3D muestra el encuadre de la pantalla con un visor de prueba; el WebView nativo no está disponible en el ejecutor de pruebas. En la app, `ModelViewer` carga el modelo interactivo y ofrece los modos AR configurados.

## Pruebas

```sh
flutter test
flutter analyze
```

Las pruebas cubren distancia, rumbos, paso por el norte, campo de visión, motor AR, sellos, fuentes simuladas, manejo de errores y capturas de interfaz. Última ejecución: **23 pruebas pasaron** y `flutter analyze` terminó sin observaciones.

## Estructura

- `lib/dominio/`: geometría, catálogo, motor AR, pasaporte, contratos y errores.
- `lib/datos/`: sensores reales y fuentes simuladas para el aula.
- `lib/presentacion/`: ViewModel y pantallas de inicio, AR y modelo 3D.
- `test/`: pruebas TDD y capturas de evidencia en `test/screenshots/`.

## Privacidad y seguridad

La ubicación se usa en el dispositivo mientras la app está abierta; no se transmite a un servidor. Si se rechaza el permiso, se puede usar el modo demo. La app muestra una advertencia para evitar caminar mirando la pantalla y mantiene la lista de lugares como alternativa a la cámara.

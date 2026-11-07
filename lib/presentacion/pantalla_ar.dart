import 'package:flutter/material.dart';

import '../dominio/geo.dart';
import '../dominio/motor_ar.dart';
import 'ar_viewmodel.dart';
import 'fondo_camara.dart';

class PantallaAr extends StatefulWidget {
  final ArViewModel Function() crearVm;
  final Widget? controlesDemo;
  const PantallaAr({super.key, required this.crearVm, this.controlesDemo});
  @override
  State<PantallaAr> createState() => _PantallaArState();
}

class _PantallaArState extends State<PantallaAr> {
  late final ArViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = widget.crearVm()..iniciar();
    vm.addListener(_actualizar);
  }

  void _actualizar() {
    if (!mounted) return;
    setState(() {});
    final l = vm.consumirSello();
    if (l != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sello conseguido: ${l.nombre}')),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    vm.removeListener(_actualizar);
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const FondoCamara(),
        Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: _panel())),
        if (vm.error != null)
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(vm.error!),
              ),
            ),
          ),
        if (vm.esperando && vm.error == null)
          const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Buscando GPS y brújula…'),
              ),
            ),
          ),
        ...vm.visibles.asMap().entries.map(
          (entry) => _etiqueta(entry.value, entry.key),
        ),
        if (widget.controlesDemo != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(child: widget.controlesDemo!),
          ),
      ],
    ),
  );
  Widget _panel() => Container(
    color: Colors.black54,
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        Expanded(
          child: Text(
            vm.usuario == null
                ? 'Dolores Hidalgo  ·  RA'
                : '${vm.rumbo == null ? '' : '${nombreCardinal(vm.rumbo!)} ${vm.rumbo!.round()}°'}  ·  ${vm.usuario}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${vm.visibles.length} lugares  ·  ${vm.pasaporte.total}/${vm.lugares.length} sellos',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
  Widget _etiqueta(LugarVisible v, int index) {
    final w = MediaQuery.sizeOf(context).width;
    const cardWidth = 190.0;
    final left = (w * v.x - cardWidth / 2).clamp(8.0, w - cardWidth - 8);
    final top =
        MediaQuery.sizeOf(context).height * (0.30 + v.profundidad * 0.18) +
        index * 100;
    return Positioned(
      left: left,
      top: top,
      child: Transform.scale(
        scale: v.escala,
        child: GestureDetector(
          onTap: () => _detalle(v),
          child: Card(
            color: Colors.white.withValues(alpha: .92),
            child: SizedBox(
              width: cardWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.lugar.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(formatearDistancia(v.distancia)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _detalle(LugarVisible v) => showModalBottomSheet<void>(
    context: context,
    builder: (c) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v.lugar.nombre, style: Theme.of(c).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(v.lugar.descripcion),
          const SizedBox(height: 12),
          Text('Dato curioso: ${v.lugar.datoCurioso}'),
          const SizedBox(height: 12),
          Text(
            'A ${formatearDistancia(v.distancia)} · ${vm.pasaporte.visitado(v.lugar.id) ? 'Sello conseguido' : 'Acércate a 40 m para ganar el sello'}',
          ),
        ],
      ),
    ),
  );
}

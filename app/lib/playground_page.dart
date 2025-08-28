import 'dart:math';

import 'package:app/node.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(200),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GraphPainter(
              size: constraints.biggest,
              nodesCount: 10,
            );
          },
        ),
      ),
    );
  }
}

class GraphPainter extends StatefulWidget {
  const GraphPainter({
    required this.size,
    this.nodesCount = 10,
    super.key,
  });

  final Size size;
  final int nodesCount;

  @override
  State<GraphPainter> createState() => _GraphPainterState();
}

class _GraphPainterState extends State<GraphPainter> {
  late List<Node> nodes;
  static final random = Random();

  void _generateNodes() {
    final offsets = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      pointsCount: widget.nodesCount,
    );
    nodes = offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
  }

  @override
  void initState() {
    super.initState();
    _generateNodes();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PlaygroundPainter(
        nodes: nodes,
      ),
    );
  }
}

class PlaygroundPainter extends CustomPainter {
  PlaygroundPainter({
    required this.nodes,
  });

  final List<Node> nodes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final node in nodes) {
      canvas.drawCircle(node.offset, 10, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

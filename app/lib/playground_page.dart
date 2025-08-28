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
  late Set<List<int>> edges;
  static final random = Random();

  void _generateNodes() {
    final offsets = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      pointsCount: widget.nodesCount,
    );
    nodes = offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
    edges = Set.from(
      List.generate(nodes.length, (sourceIndex) {
        return List.generate(2, (targetIndex) => [sourceIndex, targetIndex]);
      }).expand((i) => i),
    );
    print(edges);
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
        edges: edges,
      ),
    );
  }
}

class PlaygroundPainter extends CustomPainter {
  PlaygroundPainter({
    required this.nodes,
    required this.edges,
  });

  final List<Node> nodes;
  late Set<List<int>> edges;

  static const nodeRadius = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      canvas.drawLine(
        nodes[edge[0]].offset,
        nodes[edge[1]].offset,
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
    for (final (index, node) in nodes.indexed) {
      canvas.drawCircle(node.offset, nodeRadius, Paint()..color = Colors.white);
      paintText(
        canvas,
        nodeRadius,
        offset: node.offset,
        text: index.toString(),
        fontSize: nodeRadius * 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'dart:math';

import 'package:app/node.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

const _isDebug = false;

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

const _isGrid = true;

class _GraphPainterState extends State<GraphPainter> {
  late List<Node> nodes;
  late Set<List<int>> edges;
  static final random = Random();

  void _generateNodes() {
    late List<Offset> offsets;
    if (_isGrid) {
      offsets = generateGridPoints(
        canvasSize: widget.size,
        cellSize: widget.size * 0.2,
      );
    } else {
      offsets = generateRandomPoints(
        random: random,
        canvasSize: widget.size,
        pointsCount: widget.nodesCount,
      );
    }
    nodes = offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
    if (_isGrid) {
      // ---- Build grid edges (8-neighbor connectivity) ----
      final cols = (widget.size.width / (widget.size.width * 0.2)).floor();
      final rows = (widget.size.height / (widget.size.height * 0.2)).floor();

      final neighborDirs = [
        const Offset(1, 0), // right
        const Offset(-1, 0), // left
        const Offset(0, 1), // down
        const Offset(0, -1), // up
        // Diagonals
        const Offset(1, 1), // down-right
        const Offset(1, -1), // up-right
        const Offset(-1, 1), // down-left
        const Offset(-1, -1), // up-left
      ];

      final edgeSet = <List<int>>{};

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          final index = r * cols + c;

          for (final dir in neighborDirs) {
            final nr = r + dir.dy.toInt();
            final nc = c + dir.dx.toInt();
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              final neighborIndex = nr * cols + nc;
              // store edge as [min, max] to avoid duplicates
              edgeSet.add([index, neighborIndex]..sort());
            }
          }
        }
      }

      edges = edgeSet;
    } else {
      edges = Set<List<int>>.from(
        List<List<List<int>>>.generate(nodes.length, (sourceIndex) {
          return List.generate(2, (targetIndex) => [sourceIndex, targetIndex]);
        }).expand((i) => i),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _generateNodes();
  }

  @override
  Widget build(BuildContext context) {
    // _generateNodes();
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
      final start = nodes[edge[0]].offset;
      final end = nodes[edge[1]].offset;
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
      if (_isDebug) {
        paintText(
          canvas,
          1000,
          text: '[${edge[0]}, ${edge[1]}]',
          offset: Offset(
            (start.dx + end.dx) / 2,
            (start.dy + end.dy) / 2,
          ),
          color: Colors.yellow,
        );
      }
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

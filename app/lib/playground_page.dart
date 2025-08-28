import 'dart:math';

import 'package:app/node.dart';
import 'package:app/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _isDebug = false;
const nodeRadius = 20.0;

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
const _isCircle = true;

class _GraphPainterState extends State<GraphPainter> {
  late List<Node> nodes;
  late Set<List<int>> edges;
  late List<List<int>> adjacencyList;
  Offset? _hoverOffset;
  int _selectedNodeIndex = -1;

  static final random = Random();

  int get hoveredNodeIndex {
    if (_hoverOffset == null) return -1;
    return nodes.indexWhere(
      (node) => isWithinRadius(node.offset, _hoverOffset!, nodeRadius),
    );
  }

  List<int> get hoveredNodeNeighbors {
    if (_hoverOffset == null || hoveredNodeIndex < 0) return [];
    return adjacencyList[hoveredNodeIndex];
  }

  void _generateGraph() {
    _generateNodes();
    _generateEdges();
    _generateAdjacencyList();
  }

  void _generateNodes() {
    late List<Offset> offsets;
    if (_isGrid) {
      offsets = generateGridPoints(
        canvasSize: widget.size,
        cellSize: widget.size * 0.2,
      );
    } else if (_isCircle) {
      offsets = generateCircularOffsets(
        radius: widget.size.shortestSide / 2,
        center: widget.size.center(Offset.zero),
        count: 10,
      );
    } else {
      offsets = generateRandomPoints(
        random: random,
        canvasSize: widget.size,
        pointsCount: widget.nodesCount,
      );
    }
    nodes = offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
  }

  void _generateEdges() {
    if (nodes.isEmpty) throw Exception('Nodes not generated!');
    if (_isGrid) {
      // ---- Build grid edges (8-neighbor connectivity) ----
      final cols = (widget.size.width / (widget.size.width * 0.2)).floor();
      final rows = (widget.size.height / (widget.size.height * 0.2)).floor();
      // 8-neighborhood, but only the half that points "forward":
      // rule: dr > 0 OR (dr == 0 && dc > 0)
      const dirs = <(int dr, int dc)>[
        (0, 1), // right
        (1, 0), // down
        (1, 1), // down-right
        (-1, 1), // up-right
      ];

      final edgeList = <List<int>>[];

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          final a = r * cols + c;
          for (final (dr, dc) in dirs) {
            final nr = r + dr, nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              final b = nr * cols + nc;
              edgeList.add([a, b]); // each edge added exactly once
            }
          }
        }
      }

      edges = edgeList.toSet();
    } else {
      edges = {
        for (int i = 0; i < nodes.length; i++)
          for (int j = i + 1; j < nodes.length; j++) [i, j],
      };
    }
  }

  void _generateAdjacencyList() {
    if (edges.isEmpty) throw Exception('Edges not generated!');

    adjacencyList = List.generate(nodes.length, (index) {
      final currentEdges = edges.where((items) => items.contains(index));
      return currentEdges
          .map((edges) => edges.where((e) => e != index))
          .expand((i) => i)
          .toList()
        ..sort();
    });
  }

  void _onEnter(_) {
    //
  }

  void _onHover(PointerHoverEvent event) {
    //
    setState(() {
      _hoverOffset = event.localPosition;
    });
  }

  void _onExit(_) {
    if (_hoverOffset != null) {
      setState(() {
        _hoverOffset = null;
      });
    }
  }

  void _onPanEnd(_) {
    if (_selectedNodeIndex < 0) return;
    setState(() {
      _selectedNodeIndex = -1;
    });
  }

  void _onPanDown(DragDownDetails details) {
    final offset = details.localPosition;
    final selectedNodeIndex = nodes.indexWhere(
      (node) => isWithinRadius(node.offset, offset, nodeRadius),
    );
    if (selectedNodeIndex < 0) return;
    setState(() {
      _selectedNodeIndex = selectedNodeIndex;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_selectedNodeIndex < 0) return;
    final Node selectedNode = nodes[_selectedNodeIndex];
    nodes[_selectedNodeIndex] = selectedNode.copyWith(
      x: selectedNode.x + details.delta.dx,
      y: selectedNode.y + details.delta.dy,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _generateGraph();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onPanDown: _onPanDown,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        behavior: HitTestBehavior.opaque,
        child: ColoredBox(
          color: Colors.red.withAlpha(0),
          child: CustomPaint(
            painter: PlaygroundPainter(
              nodes: nodes,
              edges: edges,
              adjacencyList: adjacencyList,
              hoverOffset: _hoverOffset,
              hoveredNodeIndex: hoveredNodeIndex,
              selectedNodeIndex: _selectedNodeIndex,
            ),
            child: Container(),
          ),
        ),
      ),
    );
  }
}

class PlaygroundPainter extends CustomPainter {
  PlaygroundPainter({
    required this.nodes,
    required this.edges,
    required this.adjacencyList,
    this.hoverOffset,
    this.hoveredNodeIndex = -1,
    this.selectedNodeIndex = -1,
  });

  final List<Node> nodes;
  final Set<List<int>> edges;
  final List<List<int>> adjacencyList;
  final Offset? hoverOffset;
  final int selectedNodeIndex;
  final int hoveredNodeIndex;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final start = nodes[edge.first].offset;
      final end = nodes[edge.last].offset;
      final isHovered =
          hoveredNodeIndex >= 0 && edge.contains(hoveredNodeIndex);
      final isSelected =
          selectedNodeIndex >= 0 && edge.contains(selectedNodeIndex);

      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = isHovered || isSelected ? Colors.yellow : Colors.grey
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );

      if (_isDebug) {
        paintText(
          canvas,
          1000,
          text: '[$start, $end]',
          offset: Offset(
            (start.dx + end.dx) / 2,
            (start.dy + end.dy) / 2,
          ),
          color: Colors.yellow,
        );
      }
    }

    for (final (index, node) in nodes.indexed) {
      bool isSelected = selectedNodeIndex == index;
      bool isHovered = hoveredNodeIndex == index;
      bool isHoveredNeighbor =
          hoveredNodeIndex >= 0 &&
          adjacencyList[hoveredNodeIndex].contains(index);
      bool isSelectedNeighbor =
          selectedNodeIndex >= 0 &&
          adjacencyList[selectedNodeIndex].contains(
            index,
          );

      canvas.drawCircle(
        node.offset,
        nodeRadius,
        Paint()
          ..color = isSelected
              ? Colors.pink
              : isHoveredNeighbor || isSelectedNeighbor
              ? Colors.yellow
              : isHovered
              ? Colors.blue
              : Colors.white,
      );
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

  @override
  bool? hitTest(Offset position) {
    // Todo: consider
    // bool hit = path.contains(position);
    // return hit;
    return true;
  }
}

bool isWithinRadius(Offset origin, Offset target, double radius) {
  return (target - origin).distance <= radius;
}

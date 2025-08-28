import 'dart:math';

import 'package:app/node.dart';
import 'package:app/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _isDebug = false;
const nodeRadius = 20.0;

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  GraphMode _mode = GraphMode.grid;
  bool _triggerReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GraphPainter(
                    size: constraints.biggest,
                    mode: _mode,
                    nodesCount: 10,
                    triggerReset: _triggerReset,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _triggerReset = !_triggerReset;
                    });
                  },
                  child: Text('Reset'),
                ),
                SizedBox(
                  width: 400,
                  child: CustomRadio<GraphMode>(
                    selectedItem: _mode,
                    items: GraphMode.values,
                    onChanged: (mode) {
                      setState(() {
                        _mode = mode;
                      });
                    },
                    labelBuilder: (m) => m.label,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum GraphMode {
  grid('Grid'),
  circle('Circle'),
  random('Random');

  const GraphMode(this.label);

  final String label;
}

enum GraphType {
  complete,
  connected,
}

class GraphPainter extends StatefulWidget {
  const GraphPainter({
    required this.size,
    this.nodesCount = 10,
    this.mode = GraphMode.grid,
    this.triggerReset = false,
    super.key,
  });

  final Size size;
  final int nodesCount;
  final GraphMode mode;
  final bool triggerReset;

  @override
  State<GraphPainter> createState() => _GraphPainterState();
}

class _GraphPainterState extends State<GraphPainter> {
  late List<Node> nodes;
  late Set<List<int>> edges;
  late List<List<int>> adjacencyList;
  Offset? _hoverOffset;
  int _selectedNodeIndex = -1;
  int _hoveredNodeIndex = -1;

  static final random = Random();

  static const cellSizeFraction = 0.18;

  List<int> get hoveredNodeNeighbors {
    if (_hoverOffset == null || _hoveredNodeIndex < 0) return [];
    return adjacencyList[_hoveredNodeIndex];
  }

  void _generateGraph() {
    _generateNodes();
    _generateEdges();
    _generateAdjacencyList();
  }

  void _generateNodes() {
    late List<Offset> offsets;
    if (widget.mode == GraphMode.grid) {
      offsets = generateGridPoints(
        canvasSize: widget.size,
        cellSize: widget.size * cellSizeFraction,
      );
    } else if (widget.mode == GraphMode.circle) {
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
    if (widget.mode == GraphMode.grid) {
      // ---- Build grid edges (8-neighbor connectivity) ----
      final cols = (widget.size.width / (widget.size.width * cellSizeFraction))
          .floor();
      final rows =
          (widget.size.height / (widget.size.height * cellSizeFraction))
              .floor();
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
    final offset = event.localPosition;
    final hoveredNodeIndex = nodes.indexWhere(
      (node) => isWithinRadius(node.offset, offset, nodeRadius),
    );
    if (hoveredNodeIndex < 0 && _hoveredNodeIndex == hoveredNodeIndex) return;
    setState(() {
      _hoveredNodeIndex = hoveredNodeIndex;
    });
  }

  void _onExit(_) {
    if (_hoverOffset == null && _hoveredNodeIndex < 0) return;
    setState(() {
      _hoverOffset = null;
      _hoveredNodeIndex = -1;
    });
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
  void didUpdateWidget(covariant GraphPainter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.triggerReset != widget.triggerReset ||
        oldWidget.mode != widget.mode) {
      _generateGraph();
    }
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withAlpha(50))
          ),
          child: CustomPaint(
            painter: PlaygroundPainter(
              nodes: nodes,
              edges: edges,
              adjacencyList: adjacencyList,
              hoverOffset: _hoverOffset,
              hoveredNodeIndex: _hoveredNodeIndex,
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

class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.items,
    required this.selectedItem,
    this.onChanged,
    required this.labelBuilder,
  });

  final List<T> items;
  final T selectedItem;
  final ValueChanged<T>? onChanged;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        items.length,
        (index) {
          final item = items[index];
          return Flexible(
            child: GestureDetector(
              onTap: () => onChanged?.call(item),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: selectedItem == item
                      ? Colors.pink.shade100
                      : Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: index == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )
                      : index == items.length - 1
                      ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    labelBuilder(item),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

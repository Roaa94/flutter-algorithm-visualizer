import 'dart:math';

import 'package:app/graph.dart';
import 'package:app/graph_painter.dart';
import 'package:app/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'custom_radio_group.dart';
import 'node.dart';

class GraphVisualizer extends StatefulWidget {
  const GraphVisualizer({
    required this.size,
    this.nodesCount = 10,
    this.nodeRadius = 20,
    super.key,
  });

  final Size size;
  final int nodesCount;
  final double nodeRadius;

  @override
  State<GraphVisualizer> createState() => _GraphVisualizerState();
}

class _GraphVisualizerState extends State<GraphVisualizer>
    with SingleTickerProviderStateMixin {
  static const int _desiredFrameRate = 2;

  GraphMode _mode = GraphMode.grid;
  bool _paintEdges = true;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;
  final Duration _desiredFrameTime = Duration(
    milliseconds: (1000 / _desiredFrameRate).floor(),
  );

  late List<Node> nodes;
  late List<List<int>> edges;
  late List<List<int>> adjacencyList;
  Offset? _hoverOffset;
  List<int> _stack = [];
  int _selectedNodeIndex = -1;
  int _hoveredNodeIndex = -1;
  int _currentNodeIndex = 0;

  static final random = Random();

  static const cellSizeFraction = 0.18;

  List<int> get hoveredNodeNeighbors {
    if (_hoverOffset == null || _hoveredNodeIndex < 0) return [];
    return adjacencyList[_hoveredNodeIndex];
  }

  void _onTick(Duration elapsed) {
    _elapsed = elapsed;
    if (_lastElapsed != null) {
      if (_elapsed - _lastElapsed! < _desiredFrameTime) {
        return;
      }
    }
    _lastElapsed = elapsed;
    _tick();
    setState(() {});
  }

  void _tick() {
    if (_currentNodeIndex < 0) return;
    nodes[_currentNodeIndex] = nodes[_currentNodeIndex].copyWith(
      isVisited: true,
    );
    final nextIndex = _getRandomUnvisitedNeighbor(_currentNodeIndex);
    if (nextIndex >= 0) {
      // There are still unvisited neighbors
      nodes[nextIndex] = nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: nodes[_currentNodeIndex],
      );
      _stack.add(_currentNodeIndex);
      _currentNodeIndex = nextIndex;
    } else if (_stack.isNotEmpty) {
      // No neighbors left to visit
      _currentNodeIndex = _stack.removeLast();
    } else {
      // DFS completed
      _paintEdges = false;
      _currentNodeIndex = -1;
    }
  }

  int _getRandomUnvisitedNeighbor(int nodeIndex) {
    final neighbors = adjacencyList[nodeIndex];
    final unvisited = neighbors
        .where((index) => !nodes[index].isVisited)
        .toList();
    if (unvisited.isEmpty) return -1;
    return unvisited[random.nextInt(unvisited.length)];
  }

  void _generateGraph() {
    _generateNodes();
    _generateEdges();
    _generateAdjacencyList();
  }

  void _toggleEdges() {
    setState(() {
      _paintEdges = !_paintEdges;
    });
  }

  void _toggle() {
    if (_ticker.isActive) {
      _ticker.stop();
      _lastElapsed = null;
    } else {
      _ticker.start();
    }
    setState(() {});
  }

  void _onReset() {
    if (_ticker.isActive) {
      _ticker.stop(canceled: true);
    }
    _elapsed = Duration.zero;
    _lastElapsed = null;
    _currentNodeIndex = 0;
    _stack = [];
    _paintEdges = true;
    _generateGraph();
    setState(() {});
  }

  void _onModeChanged(GraphMode mode) {
    setState(() {
      _mode = mode;
    });
    _onReset();
  }

  void _generateNodes() {
    late List<Offset> offsets;
    if (_mode == GraphMode.grid) {
      offsets = generateGridPoints(
        canvasSize: widget.size,
        cellSize: widget.size * cellSizeFraction,
      );
    } else if (_mode == GraphMode.circle) {
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
    edges = [];
    if (_mode == GraphMode.grid) {
      edges = generateGridEdges(widget.size, cellSizeFraction);
    } else {
      edges = [
        for (int i = 0; i < nodes.length; i++)
          for (int j = i + 1; j < nodes.length; j++) [i, j],
      ];
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
      (node) => isWithinRadius(node.offset, offset, widget.nodeRadius),
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
      (node) => isWithinRadius(node.offset, offset, widget.nodeRadius),
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
    _ticker = createTicker(_onTick);
    _generateGraph();
  }

  @override
  void didUpdateWidget(covariant GraphVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size) {
      _onReset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
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
                  border: Border.all(color: Colors.white.withAlpha(50)),
                ),
                child: CustomPaint(
                  painter: GraphPainter(
                    nodes: nodes,
                    edges: edges,
                    nodeRadius: widget.nodeRadius,
                    adjacencyList: adjacencyList,
                    stack: _stack,
                    paintEdges: _paintEdges,
                    hoverOffset: _hoverOffset,
                    hoveredNodeIndex: _hoveredNodeIndex,
                    selectedNodeIndex: _selectedNodeIndex,
                    currentNodeIndex: _currentNodeIndex,
                  ),
                  child: SizedBox(
                    width: widget.size.width,
                    height: widget.size.height,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              IconButton(
                onPressed: _toggle,
                color: Colors.white,
                icon: Icon(
                  _ticker.isActive ? Icons.pause : Icons.play_arrow,
                ),
              ),
              IconButton(
                onPressed: _toggleEdges,
                color: Colors.white,
                icon: Icon(
                  _paintEdges ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              ElevatedButton(
                onPressed: _onReset,
                child: Text('Reset'),
              ),
              Flexible(
                child: SizedBox(
                  width: 400,
                  child: CustomRadioGroup<GraphMode>(
                    selectedItem: _mode,
                    items: GraphMode.values,
                    onChanged: _onModeChanged,
                    labelBuilder: (m) => m.label,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

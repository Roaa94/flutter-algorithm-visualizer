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
    this.cellSizeFraction = 0.18,
    super.key,
  });

  final Size size;
  final int nodesCount;
  final double nodeRadius;
  final double cellSizeFraction;

  @override
  State<GraphVisualizer> createState() => _GraphVisualizerState();
}

class _GraphVisualizerState extends State<GraphVisualizer>
    with SingleTickerProviderStateMixin {
  static const int _desiredFrameRate = 2;
  Algorithm _algorithm = Algorithm.bfs;

  GraphMode _mode = GraphMode.grid;
  bool _paintEdges = true;
  bool _hasDiagonalEdges = true;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;
  final Duration _desiredFrameTime = Duration(
    milliseconds: (1000 / _desiredFrameRate).floor(),
  );

  late Graph _graph;

  Offset? _hoverOffset;
  int _selectedNodeIndex = -1;
  int _hoveredNodeIndex = -1;
  int? _startingNodeIndex;

  List<int> get hoveredNodeNeighbors {
    if (_hoverOffset == null || _hoveredNodeIndex < 0) return [];
    return _graph.adjacencyList[_hoveredNodeIndex];
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
    final complete = _algorithm == Algorithm.dfs
        ? _graph.dfsStep(randomized: true)
        : _graph.bfsStep(randomized: false);
    if (complete) {
      _paintEdges = false;
    }
  }

  void _initGraph() {
    _graph = Graph(
      size: widget.size,
      nodesCount: widget.nodesCount,
      cellSizeFraction: widget.cellSizeFraction,
      hasDiagonalEdges: _hasDiagonalEdges,
      startingNodeIndex: _startingNodeIndex,
      mode: _mode,
    );
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
    _paintEdges = true;
    _startingNodeIndex = null;
    _initGraph();
    setState(() {});
  }

  void _onModeChanged(GraphMode mode) {
    setState(() {
      _mode = mode;
    });
    _onReset();
  }

  void _onAlgorithmChanged(Algorithm algorithm) {
    setState(() {
      _algorithm = algorithm;
    });
    _onReset();
  }

  void _onDiagonalEdgesToggle() {
    setState(() {
      _hasDiagonalEdges = !_hasDiagonalEdges;
    });
    _onReset();
  }

  void _onEnter(_) {
    //
  }

  void _onHover(PointerHoverEvent event) {
    final offset = event.localPosition;
    final hoveredNodeIndex = _graph.nodes.indexWhere(
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
    final selectedNodeIndex = _graph.nodes.indexWhere(
      (node) => isWithinRadius(node.offset, offset, widget.nodeRadius),
    );
    if (selectedNodeIndex < 0) return;

    _startingNodeIndex = selectedNodeIndex;
    _graph.activeNodeIndex = _startingNodeIndex!;
    _selectedNodeIndex = selectedNodeIndex;
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_selectedNodeIndex < 0) return;
    final Node selectedNode = _graph.nodes[_selectedNodeIndex];
    _graph.nodes[_selectedNodeIndex] = selectedNode.copyWith(
      x: selectedNode.x + details.delta.dx,
      y: selectedNode.y + details.delta.dy,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _initGraph();
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
                    graph: _graph,
                    nodeRadius: widget.nodeRadius,
                    paintEdges: _paintEdges,
                    hoverOffset: _hoverOffset,
                    hoveredNodeIndex: _hoveredNodeIndex,
                    selectedNodeIndex: _selectedNodeIndex,
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
              Opacity(
                opacity: _hasDiagonalEdges ? 1 : 0.5,
                child: IconButton(
                  onPressed: _onDiagonalEdgesToggle,
                  color: Colors.white,
                  icon: Icon(
                    Icons.call_received,
                  ),
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
              Flexible(
                child: SizedBox(
                  width: 250,
                  child: CustomRadioGroup<Algorithm>(
                    selectedItem: _algorithm,
                    items: Algorithm.values,
                    onChanged: _onAlgorithmChanged,
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

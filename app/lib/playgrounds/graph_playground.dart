import 'package:app/models/algorithms.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/node.dart';
import 'package:app/painters/graph_painter.dart';
import 'package:app/utils.dart';
import 'package:app/widgets/custom_radio_group.dart';
import 'package:app/widgets/slider_tile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GraphPlayground extends StatefulWidget {
  const GraphPlayground({
    required this.size,
    super.key,
  });

  final Size size;

  @override
  State<GraphPlayground> createState() => _GraphPlaygroundState();
}

class _GraphPlaygroundState extends State<GraphPlayground>
    with SingleTickerProviderStateMixin {
  int _desiredFrameRate = 2;
  GraphTraversalAlgorithm _algorithm = GraphTraversalAlgorithm.dfs;
  double _cellSizeFraction = 0.18;
  int _nodesCount = 10;
  double _nodesRadius = 20;

  GraphMode _mode = GraphMode.grid;
  bool _paintEdges = true;
  bool _hasDiagonalEdges = true;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;

  Duration get _desiredFrameTime => Duration(
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
    final complete = _algorithm == GraphTraversalAlgorithm.dfs
        ? _graph.dfsStep(randomized: true)
        : _graph.bfsStep(randomized: false);
    if (complete) {
      _paintEdges = false;
    }
  }

  void _initGraph() {
    _graph = Graph(
      size: widget.size,
      nodesCount: _nodesCount,
      cellSize: widget.size * _cellSizeFraction,
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

  void _onFrameRateChanged(int value) {
    setState(() {
      _desiredFrameRate = value;
    });
  }

  void _onModeChanged(GraphMode mode) {
    setState(() {
      _mode = mode;
    });
    _onReset();
  }

  void _onAlgorithmChanged(GraphTraversalAlgorithm algorithm) {
    setState(() {
      _algorithm = algorithm;
    });
    _onReset();
  }

  void _onCellSizeChanged(double value) {
    setState(() {
      _cellSizeFraction = value;
    });
    _onReset();
  }

  void _onNodesCountChanged(int value) {
    setState(() {
      _nodesCount = value;
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
      (node) => isWithinRadius(node.offset, offset, _nodesRadius),
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
      (node) => isWithinRadius(node.offset, offset, _nodesRadius),
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
  void didUpdateWidget(covariant GraphPlayground oldWidget) {
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
                    nodeRadius: _nodesRadius,
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
                  child: CustomRadioGroup<GraphTraversalAlgorithm>(
                    selectedItem: _algorithm,
                    items: GraphTraversalAlgorithm.values,
                    onChanged: _onAlgorithmChanged,
                    labelBuilder: (m) => m.label,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 30,
            children: [
              if (_mode == GraphMode.grid)
                SliderTile(
                  label: 'Grid Cell Size',
                  value: _cellSizeFraction,
                  min: 0.05,
                  max: 0.5,
                  onChanged: _onCellSizeChanged,
                ),
              if (_mode != GraphMode.grid)
                SliderTile(
                  label: 'Nodes count',
                  value: _nodesCount.toDouble(),
                  min: 2,
                  max: 50,
                  onChanged: (value) => _onNodesCountChanged(value.toInt()),
                ),
              SliderTile(
                label: 'Nodes Radius',
                value: _nodesRadius,
                min: 1,
                max: 40,
                onChanged: (value) {
                  setState(() {
                    _nodesRadius = value;
                  });
                },
              ),
              SliderTile(
                label: 'Frames per second',
                value: _desiredFrameRate,
                min: 1,
                max: 60,
                onChanged: (value) => _onFrameRateChanged(value.toInt()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

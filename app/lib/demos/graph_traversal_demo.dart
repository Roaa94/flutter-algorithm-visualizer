import 'package:app/models/algorithms.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/graph_builder.dart';
import 'package:app/models/node.dart';
import 'package:app/painters/graph_demo_painter.dart';
import 'package:app/utils.dart';
import 'package:app/widgets/demo_memory_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GraphTraversalDemo extends StatefulWidget {
  const GraphTraversalDemo({
    required this.size,
    this.hasControls = false,
    this.mode = GraphMode.grid,
    this.algorithmType = GraphTraversalAlgorithmType.dfs,
    this.playTrigger = false,
    this.resetTrigger = false,
    this.startingNodeIndex,
    this.frameRate = 60,
    this.nodesPerRow = 3,
    this.nodesPerCol = 3,
    this.showMemory = false,
    this.nextTrigger = false,
    this.hideEdgesWhenComplete = false,
    this.hasDiagonalEdges = true,
    this.nodeRadius = 35,
    this.showNodeIndex = true,
    this.edgeStrokeWidth = 4.0,
    this.mazeView = false,
    this.isSquareGrid = false,
    super.key,
  });

  final Size size;
  final bool hasControls;
  final GraphMode mode;
  final GraphTraversalAlgorithmType algorithmType;
  final int? startingNodeIndex;
  final int frameRate;
  final int nodesPerRow;
  final int nodesPerCol;
  final bool showMemory;
  final bool playTrigger;
  final bool resetTrigger;
  final bool nextTrigger;
  final bool hideEdgesWhenComplete;
  final bool hasDiagonalEdges;
  final double nodeRadius;
  final bool showNodeIndex;
  final double edgeStrokeWidth;
  final bool mazeView;
  final bool isSquareGrid;

  @override
  State<GraphTraversalDemo> createState() => _GraphTraversalDemoState();
}

class _GraphTraversalDemoState extends State<GraphTraversalDemo>
    with SingleTickerProviderStateMixin {
  late int _desiredFrameRate;
  late GraphTraversalAlgorithmType _selectedAlgorithmType;
  final _nodesCount = 10;

  late GraphAlgorithm _algorithm;

  late GraphMode _mode;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;
  bool _paintEdges = true;

  Size get cellSize => Size(
    widget.size.width / widget.nodesPerCol,
    (widget.mazeView || widget.isSquareGrid
        ? (widget.size.width / widget.nodesPerCol)
        : (widget.size.height / widget.nodesPerRow)),
  );

  GraphBuilder get graphBuilder => GraphBuilder(
    mode: _mode,
    size: widget.size,
    cellSize: cellSize,
    nodesCount: _nodesCount,
    hasDiagonalEdges: widget.hasDiagonalEdges,
  );

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
  }

  void _tick() {
    final isCompleted = _algorithm.traverseStep();
    if (isCompleted && widget.hideEdgesWhenComplete) {
      _paintEdges = false;
    }
    setState(() {});
  }

  void _initGraph() {
    final nodes = graphBuilder.generateNodes();
    final edges = graphBuilder.generateEdges(nodes);
    _graph = Graph(
      nodes: nodes,
      edges: edges,
    );
  }

  void _initAlgorithm() {
    _algorithm = _selectedAlgorithmType.getAlgorithm(
      _graph,
      randomized: true,
      startingNodeIndex: _startingNodeIndex,
    );
  }

  void _toggleTicker() {
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
    _startingNodeIndex = null;
    _paintEdges = true;
    _initGraph();
    _initAlgorithm();
    setState(() {});
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
    _algorithm.activeNodeIndex = _startingNodeIndex!;
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
    _mode = widget.mode;
    _selectedAlgorithmType = widget.algorithmType;
    if (widget.startingNodeIndex != null) {
      _startingNodeIndex = widget.startingNodeIndex;
    }
    _desiredFrameRate = widget.frameRate;
    _ticker = createTicker(_onTick);
    _initGraph();
    _initAlgorithm();
    if (widget.playTrigger) {
      _toggleTicker();
    }
  }

  @override
  void didUpdateWidget(covariant GraphTraversalDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size ||
        oldWidget.mode != widget.mode ||
        oldWidget.resetTrigger != widget.resetTrigger) {
      _onReset();
    }
    if (oldWidget.playTrigger != widget.playTrigger) {
      _toggleTicker();
    }
    if (oldWidget.nextTrigger != widget.nextTrigger) {
      _tick();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onHover: _onHover,
          onExit: _onExit,
          child: GestureDetector(
            onPanDown: _onPanDown,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: GraphDemoPainter(
                graph: _graph,
                nodeRadius: widget.nodeRadius,
                hoverOffset: _hoverOffset,
                hoveredNodeIndex: _hoveredNodeIndex,
                selectedNodeIndex: _selectedNodeIndex,
                activeNodeIndex: _algorithm.activeNodeIndex,
                stack: _algorithm.memory,
                paintEdges: _paintEdges,
                showNodeIndex: widget.showNodeIndex,
                edgeStrokeWidth: widget.edgeStrokeWidth,
                mazeView: widget.mazeView,
                cellSize: cellSize.width,
              ),
              child: SizedBox(
                width: widget.size.width,
                height: widget.size.height,
              ),
            ),
          ),
        ),
        if (widget.showMemory)
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: 120,
            child: DemoMemoryView(
              algorithm: _algorithm,
              selectedAlgorithmType: _selectedAlgorithmType,
            ),
          ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:app/demos/maze_solving_demo_painter.dart';
import 'package:app/models/algorithms.dart';
import 'package:app/models/dfs.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/graph_builder.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MazeSolvingDemo extends StatefulWidget {
  const MazeSolvingDemo({
    required this.size,
    this.playTrigger = false,
    this.resetTrigger = false,
    this.nextTrigger = false,
    this.frameRate = 60,
    this.nodesPerCol = 10,
    this.selectedAlgorithmType = MazeSolvingAlgorithmType.bfs,
    this.mazeView = true,
    super.key,
  });

  final Size size;
  final bool playTrigger;
  final bool resetTrigger;
  final bool nextTrigger;
  final int frameRate;
  final int nodesPerCol;
  final MazeSolvingAlgorithmType selectedAlgorithmType;
  final bool mazeView;

  @override
  State<MazeSolvingDemo> createState() => _MazeSolvingDemoState();
}

class _MazeSolvingDemoState extends State<MazeSolvingDemo>
    with SingleTickerProviderStateMixin {
  late GraphAlgorithm _algorithm;
  List<int>? _mazeSolutionPath;

  int _startingNodeIndex = 0;
  bool _selectingStart = true;
  int _endingNodeIndex = -1;

  Size get cellSize => Size(
    widget.size.width / widget.nodesPerCol,
    widget.size.width / widget.nodesPerCol,
  );

  double get nodeRadius => cellSize.width / 4 * 0.6;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;

  Duration get _desiredFrameTime => Duration(
    milliseconds: (1000 / widget.frameRate).floor(),
  );

  // The graph used to generate the maz via a Maze generation algorithm
  // When built with DFS, this graph contains the solution already
  late Graph _originalGraph;

  // The graph resulting from performing a maze generation algorithm on the
  // base graph.
  // If it was generated via DFS, this will be the resulting tree of the
  // DFS algorithm.
  late Graph _mazeGraph;

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
    final path = _algorithm.findStep(_endingNodeIndex);
    if (path != null && path.isNotEmpty) {
      // A path was found!
      log('Maze solution: $path');
      _mazeSolutionPath = path;
    }
    setState(() {});
  }

  void _onTapDown(TapDownDetails details) {
    if (_ticker.isActive) return;
    final offset = details.localPosition;
    final selectedNodeIndex = _mazeGraph.nodes.indexWhere(
      (node) => isWithinRadius(node.offset, offset, nodeRadius),
    );
    if (selectedNodeIndex < 0) return;
    if (_selectingStart) {
      _startingNodeIndex = selectedNodeIndex;
      _initAlgorithm();
    } else {
      _endingNodeIndex = selectedNodeIndex;
    }
    _selectingStart = !_selectingStart;
    setState(() {});
  }

  void _initGraph() {
    final mazeGenerationGraphBuilder = GraphBuilder(
      mode: GraphMode.grid,
      size: widget.size,
      cellSize: cellSize,
      hasDiagonalEdges: false,
    );
    final nodes = mazeGenerationGraphBuilder.generateNodes();
    final edges = mazeGenerationGraphBuilder.generateEdges(nodes);
    _originalGraph = Graph(
      nodes: nodes,
      edges: edges,
    );
  }

  void _buildMaze() {
    _mazeGraph = DFS(_originalGraph).execute();
    _endingNodeIndex = _mazeGraph.nodes.length - 1;
  }

  void _initAlgorithm() {
    _algorithm = widget.selectedAlgorithmType.getAlgorithm(
      _mazeGraph,
      randomized: false,
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

  void _onReset({bool resetOriginalGraph = true}) {
    if (_ticker.isActive) {
      _ticker.stop(canceled: true);
    }
    _elapsed = Duration.zero;
    _lastElapsed = null;
    _mazeSolutionPath = null;
    _startingNodeIndex = 0;
    _selectingStart = true;
    if (resetOriginalGraph) {
      _initGraph();
    }
    _buildMaze();
    _initAlgorithm();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _initGraph();
    _buildMaze();
    _initAlgorithm();
    if (widget.playTrigger) {
      _toggleTicker();
    }
  }

  @override
  void didUpdateWidget(covariant MazeSolvingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size ||
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
    return GestureDetector(
      onTapDown: _onTapDown,
      child: CustomPaint(
        painter: MazeSolvingDemoPainter(
          originalGraph: _originalGraph,
          mazeGraph: _mazeGraph,
          mazeView: widget.mazeView,
          cellSize: cellSize.width,
          nodeRadius: nodeRadius,
          activeNodeIndex: _algorithm.activeNodeIndex,
          stack: _algorithm.memory,
          mazeSolutionPath: _mazeSolutionPath,
          startingNodeIndex: _startingNodeIndex,
          endingNodeIndex: _endingNodeIndex,
        ),
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
        ),
      ),
    );
  }
}

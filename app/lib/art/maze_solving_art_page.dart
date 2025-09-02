import 'dart:developer';

import 'package:app/models/algorithms.dart';
import 'package:app/models/dfs.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/graph_builder.dart';
import 'package:app/painters/maze_solving_art_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MazeSolvingArtPage extends StatelessWidget {
  const MazeSolvingArtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MazeSolvingArtPageContent(
        size: MediaQuery.sizeOf(context),
      ),
    );
  }
}

class MazeSolvingArtPageContent extends StatefulWidget {
  const MazeSolvingArtPageContent({
    required this.size,
    super.key,
  });

  final Size size;

  @override
  State<MazeSolvingArtPageContent> createState() =>
      _MazeSolvingArtPageContentState();
}

class _MazeSolvingArtPageContentState extends State<MazeSolvingArtPageContent>
    with SingleTickerProviderStateMixin {
  final int _desiredFrameRate = 60;
  final _selectedAlgorithmType = AlgorithmType.bfs;
  late GraphAlgorithm _algorithm;
  List<int>? _mazeSolutionPath;

  int _startingNodeIndex = 0;
  int _endingNodeIndex = -1;

  Size get cellSize => Size(20, 20);

  double get nodeRadius => cellSize.width / 4 * 0.6;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;

  Duration get _desiredFrameTime => Duration(
    milliseconds: (1000 / _desiredFrameRate).floor(),
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
    _algorithm = _selectedAlgorithmType.getAlgorithm(
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
    _ticker.start();
  }

  @override
  void didUpdateWidget(covariant MazeSolvingArtPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size) {
      _onReset();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: MazeSolvingArtPainter(
          originalGraph: _originalGraph,
          mazeGraph: _mazeGraph,
          cellSize: cellSize.width,
          nodeRadius: nodeRadius,
          solvingAlgorithm: _algorithm,
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

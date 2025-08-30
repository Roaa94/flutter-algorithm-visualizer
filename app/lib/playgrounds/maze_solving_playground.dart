import 'dart:developer';

import 'package:app/models/algorithms.dart';
import 'package:app/models/dfs.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/graph_builder.dart';
import 'package:app/painters/maze_solving_painter.dart';
import 'package:app/utils.dart';
import 'package:app/widgets/custom_checkbox.dart';
import 'package:app/widgets/custom_radio_group.dart';
import 'package:app/widgets/memory_view.dart';
import 'package:app/widgets/slider_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MazeSolvingPlayground extends StatefulWidget {
  const MazeSolvingPlayground({
    required this.size,
    super.key,
  });

  final Size size;

  @override
  State<MazeSolvingPlayground> createState() => _MazeSolvingPlaygroundState();
}

class _MazeSolvingPlaygroundState extends State<MazeSolvingPlayground>
    with SingleTickerProviderStateMixin {
  int _desiredFrameRate = 20;
  MazeSolvingAlgorithmType _selectedAlgorithmType =
      MazeSolvingAlgorithmType.dfs;
  late GraphAlgorithm _algorithm;
  List<int>? _mazeSolutionPath;

  int _startingNodeIndex = 0;
  bool _selectingStart = true;
  int _endingNodeIndex = -1;

  double _cellSizeFraction = 0.17;
  bool _showOriginalGraph = false;
  bool _showMazeCells = false;
  bool _showMazeGraph = true;

  Size get cellSize => Size(
    widget.size.width * _cellSizeFraction,
    widget.size.width * _cellSizeFraction,
  );

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
    _selectingStart = true;
    if (resetOriginalGraph) {
      _initGraph();
    }
    _buildMaze();
    _initAlgorithm();
    setState(() {});
  }

  void _onFrameRateChanged(int value) {
    setState(() {
      _desiredFrameRate = value;
    });
  }

  void _onAlgorithmChanged(MazeSolvingAlgorithmType algorithm) {
    setState(() {
      _selectedAlgorithmType = algorithm;
    });
    _onReset(resetOriginalGraph: false);
  }

  void _onCellSizeChanged(double value) {
    setState(() {
      _cellSizeFraction = value;
    });
    _onReset();
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _initGraph();
    _buildMaze();
    _initAlgorithm();
  }

  @override
  void didUpdateWidget(covariant MazeSolvingPlayground oldWidget) {
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
    return Center(
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTapDown: _onTapDown,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withAlpha(50)),
                  ),
                  child: CustomPaint(
                    painter: MazeSolvingPainter(
                      originalGraph: _originalGraph,
                      mazeGraph: _mazeGraph,
                      showOriginalGraph: _showOriginalGraph,
                      showMazeCells: _showMazeCells,
                      showMazeGraph: _showMazeGraph,
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
                ),
              ),
              Positioned(
                left: widget.size.width,
                bottom: 0,
                top: 0,
                width: 100,
                child: MemoryView(
                  algorithm: _algorithm,
                  selectedAlgorithmType: _selectedAlgorithmType,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              IconButton(
                onPressed: _toggleTicker,
                color: Colors.white,
                icon: Icon(
                  _ticker.isActive ? Icons.pause : Icons.play_arrow,
                ),
              ),
              IconButton(
                onPressed: _tick,
                color: Colors.white,
                icon: Icon(Icons.skip_next),
              ),
              ElevatedButton(
                onPressed: () => _onReset(resetOriginalGraph: false),
                child: Text('Reset Solver'),
              ),
              ElevatedButton(
                onPressed: _onReset,
                child: Text('Regenerate maze'),
              ),
              Flexible(
                child: SizedBox(
                  width: 250,
                  child: CustomRadioGroup<MazeSolvingAlgorithmType>(
                    selectedItem: _selectedAlgorithmType,
                    items: MazeSolvingAlgorithmType.values,
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
              CustomCheckbox(
                value: _showMazeCells,
                onChanged: (value) => setState(() {
                  _showMazeCells = value;
                }),
                label: 'Maze View',
              ),
              CustomCheckbox(
                value: _showOriginalGraph,
                onChanged: (value) => setState(() {
                  _showOriginalGraph = value;
                }),
                label: 'Original Graph',
              ),
              CustomCheckbox(
                value: _showMazeGraph,
                onChanged: (value) => setState(() {
                  _showMazeGraph = value;
                }),
                label: 'Maze Graph',
              ),
              SliderTile(
                label: 'Grid Cell Size',
                value: _cellSizeFraction,
                min: 0.015,
                max: 0.5,
                onChanged: _onCellSizeChanged,
              ),
              SliderTile(
                label: 'FPS',
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

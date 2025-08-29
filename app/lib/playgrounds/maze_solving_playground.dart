import 'package:app/models/algorithms.dart';
import 'package:app/models/dfs.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/graph_builder.dart';
import 'package:app/painters/maze_solving_painter.dart';
import 'package:app/widgets/custom_radio_group.dart';
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
  MazeSolvingAlgorithmType _selectedAlgorithm = MazeSolvingAlgorithmType.dfs;
  late Algorithm _algorithm;

  double _cellSizeFraction = 0.1;
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
    setState(() {});
  }

  void _tick() {
    final isCompleted = _algorithm.step();
    if (isCompleted) {
      //
    }
  }

  void _initMaze() {
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
    _mazeGraph = DFS(_originalGraph).execute();
  }

  void _initAlgorithm() {
    _algorithm = _selectedAlgorithm.getAlgorithm(
      _mazeGraph,
      randomized: true,
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
    _initMaze();
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
      _selectedAlgorithm = algorithm;
    });
    _onReset();
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
    _initMaze();
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
          DecoratedBox(
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
                stack: _algorithm.stack,
              ),
              child: SizedBox(
                width: widget.size.width,
                height: widget.size.height,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showMazeCells = !_showMazeCells;
                  });
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      _showMazeCells ? Icons.visibility : Icons.visibility_off,
                    ),
                    Text('Maze View'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showOriginalGraph = !_showOriginalGraph;
                  });
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      _showOriginalGraph
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    Text('Original Graph'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showMazeGraph = !_showMazeGraph;
                  });
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      _showMazeGraph ? Icons.visibility : Icons.visibility_off,
                    ),
                    Text('Maze Graph'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _onReset,
                child: Text('Regenerate maze'),
              ),
              Flexible(
                child: SizedBox(
                  width: 250,
                  child: CustomRadioGroup<MazeSolvingAlgorithmType>(
                    selectedItem: _selectedAlgorithm,
                    items: MazeSolvingAlgorithmType.values,
                    onChanged: _onAlgorithmChanged,
                    labelBuilder: (m) => m.label,
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleTicker,
                color: Colors.white,
                icon: Icon(
                  _ticker.isActive ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 30,
            children: [
              SliderTile(
                label: 'Grid Cell Size',
                value: _cellSizeFraction,
                min: 0.02,
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

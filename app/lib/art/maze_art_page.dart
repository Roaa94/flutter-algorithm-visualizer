import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/algorithms.dart' show GraphAlgorithm;
import '../models/dfs.dart';
import '../models/graph.dart';
import '../models/graph_builder.dart' show GraphBuilder;
import '../painters/maze_art_painter.dart';

const _kIsSlowDownEnabled = false;

class MazeArtPage extends StatelessWidget {
  const MazeArtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MazeArtDemo(
        size: MediaQuery.sizeOf(context),
      ),
    );
  }
}

class MazeArtDemo extends StatefulWidget {
  const MazeArtDemo({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<MazeArtDemo> createState() => _MazeArtDemoState();
}

class _MazeArtDemoState extends State<MazeArtDemo>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;
  int _desiredFrameRate = 2;

  Duration get _desiredFrameTime => Duration(
    milliseconds: (1000 / _desiredFrameRate).floor(),
  );

  GraphBuilder get graphBuilder => GraphBuilder(
    mode: GraphMode.grid,
    size: widget.size,
    cellSize: cellSize,
    hasDiagonalEdges: false,
  );

  static const cellSize = Size(15, 15);

  late Graph _mazeGraph;
  late GraphAlgorithm _algorithm;

  void _onTick(Duration elapsed) {
    _elapsed = elapsed;
    if (_lastElapsed != null && _kIsSlowDownEnabled) {
      if (_elapsed - _lastElapsed! < _desiredFrameTime) {
        return;
      }
    }
    _lastElapsed = elapsed;
    _tick();
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

  void _tick() {
    final complete = _algorithm.traverseStep();
    if (complete) {
      //
    }
    setState(() {});
  }

  void _init() {
    print('Size: ${widget.size}');
    final nodes = graphBuilder.generateNodes();
    final edges = graphBuilder.generateEdges(nodes);
    _mazeGraph = Graph(
      nodes: nodes,
      edges: edges,
    );
    _algorithm = DFS(
      _mazeGraph,
      randomized: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _init();
    if (mounted) _ticker.start();
  }

  void _onReset() {
    _init();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant MazeArtDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.size != oldWidget.size) {
      _onReset();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: MazeArtPainter(
          graph: _mazeGraph,
          cellSize: cellSize.width,
          dfs: _algorithm as DFS,
        ),
      ),
    );
  }
}

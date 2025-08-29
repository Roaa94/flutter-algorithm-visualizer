import 'package:app/graph.dart';
import 'package:app/maze_painter.dart';
import 'package:app/slider_tile.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'custom_radio_group.dart';

class MazeVisualizer extends StatefulWidget {
  const MazeVisualizer({
    required this.size,
    super.key,
  });

  final Size size;

  @override
  State<MazeVisualizer> createState() => _MazeVisualizerState();
}

class _MazeVisualizerState extends State<MazeVisualizer>
    with SingleTickerProviderStateMixin {
  int _desiredFrameRate = 2;
  Algorithm _algorithm = Algorithm.dfs;
  double _cellSizeFraction = 0.18;
  double _nodesRadius = 20;
  bool _graphView = true;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;

  Duration get _desiredFrameTime => Duration(
    milliseconds: (1000 / _desiredFrameRate).floor(),
  );

  late Graph _graph;

  int? _startingNodeIndex;

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
    if (_algorithm == Algorithm.dfs) {
      _graph.dfsStep(randomized: true);
    } else {
      _graph.bfsStep(randomized: true);
    }
  }

  void _initGraph() {
    _graph = Graph(
      size: widget.size,
      cellSize: Size(
        widget.size.width * _cellSizeFraction,
        widget.size.width * _cellSizeFraction,
      ),
      hasDiagonalEdges: false,
      startingNodeIndex: _startingNodeIndex,
      mode: GraphMode.grid,
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
    _initGraph();
    setState(() {});
  }

  void _onFrameRateChanged(int value) {
    setState(() {
      _desiredFrameRate = value;
    });
  }

  void _onAlgorithmChanged(Algorithm algorithm) {
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

  void _onTapDown(TapDownDetails details) {
    final offset = details.localPosition;
    final selectedNodeIndex = _graph.nodes.indexWhere(
      (node) => isWithinRadius(node.offset, offset, _nodesRadius),
    );
    if (selectedNodeIndex < 0) return;

    _startingNodeIndex = selectedNodeIndex;
    _graph.activeNodeIndex = _startingNodeIndex!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _initGraph();
  }

  @override
  void didUpdateWidget(covariant MazeVisualizer oldWidget) {
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
          GestureDetector(
            onTapDown: _onTapDown,
            behavior: HitTestBehavior.opaque,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withAlpha(50)),
              ),
              child: CustomPaint(
                painter: MazePainter(
                  graph: _graph,
                  graphView: _graphView,
                  mazeView: !_graphView,
                  cellSize: widget.size.width * _cellSizeFraction,
                ),
                child: SizedBox(
                  width: widget.size.width,
                  height: widget.size.height,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              IconButton(
                onPressed: _toggleTicker,
                color: Colors.white,
                icon: Icon(
                  _ticker.isActive ? Icons.pause : Icons.play_arrow,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _graphView = !_graphView;
                  });
                },
                color: Colors.white,
                icon: Icon(
                  _graphView ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              ElevatedButton(
                onPressed: _onReset,
                child: Text('Reset'),
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

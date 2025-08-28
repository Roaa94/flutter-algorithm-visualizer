import 'dart:developer';
import 'dart:math' hide log;

import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'cell.dart';

const mazeSize = 600.0;
const cellSize = 60.0;
const cols = mazeSize ~/ cellSize;
const rows = mazeSize ~/ cellSize;
const cellCount = cols * rows;

class MazesPage extends StatelessWidget {
  const MazesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: const MazePlayground(),
    );
  }
}

class MazePlayground extends StatefulWidget {
  const MazePlayground({super.key});

  @override
  State<MazePlayground> createState() => _MazePlaygroundState();
}

class _MazePlaygroundState extends State<MazePlayground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Duration? _lastElapsed;
  static const int _desiredFrameRate = 2; // 1 frame per second
  static final random = Random();

  final Duration _desiredFrameTime = Duration(
    milliseconds: (1000 / _desiredFrameRate).floor(),
  );

  late List<Cell> cells;
  List<int> stack = [];
  late int _currentCellIndex;

  void _onTick(Duration elapsed) {
    _elapsed = elapsed;
    if (_lastElapsed != null) {
      if (_elapsed - _lastElapsed! < _desiredFrameTime) {
        return;
      }
    }
    _lastElapsed = elapsed;
    _updateMaze();
    setState(() {});
  }

  void _updateMaze() {
    if (_currentCellIndex < cells.length) {
      cells[_currentCellIndex] = cells[_currentCellIndex].copyWith(
        visited: true,
      );
      final nextIndex = _getNextUnvisitedCell();
      if (nextIndex >= 0) {
        cells[nextIndex] = cells[nextIndex].copyWith(visited: true);
        stack.add(_currentCellIndex);
        _removeWalls(_currentCellIndex, nextIndex);
        _currentCellIndex = nextIndex;
      } else if (stack.isNotEmpty) {
        _currentCellIndex = stack.removeLast();
      }
    }
  }

  void _removeWalls(int currentIndex, int nextIndex) {
    final current = cells[currentIndex];
    final next = cells[nextIndex];
    final dx = next.x - current.x;
    final dy = next.y - current.y;
    // Map of movement delta -> [current wall to remove, next wall to remove]
    const directionMap = {
      (1, 0): [WallSide.right, WallSide.left],
      (-1, 0): [WallSide.left, WallSide.right],
      (0, 1): [WallSide.bottom, WallSide.top],
      (0, -1): [WallSide.top, WallSide.bottom],
    };

    final wallsToRemove = directionMap[(dx, dy)];
    if (wallsToRemove != null) {
      cells[currentIndex] = current.copyWith(
        walls: {...current.walls, wallsToRemove[0]: false},
      );
      cells[nextIndex] = next.copyWith(
        walls: {...next.walls, wallsToRemove[1]: false},
      );
    }
  }

  int _getNextUnvisitedCell() {
    final currentCell = cells[_currentCellIndex];
    final unvisitedNeighborIndices = <int>[
      indexByCoords(currentCell.x, currentCell.y - 1, cols, rows),
      indexByCoords(currentCell.x + 1, currentCell.y, cols, rows),
      indexByCoords(currentCell.x, currentCell.y + 1, cols, rows),
      indexByCoords(currentCell.x - 1, currentCell.y, cols, rows),
    ].where((index) => index >= 0 && !cells[index].visited).toList();
    if (unvisitedNeighborIndices.isEmpty) return -1;
    final randomIndex = random.nextInt(unvisitedNeighborIndices.length);
    return unvisitedNeighborIndices[randomIndex];
  }

  void _initCells() {
    cells = List.generate(cellCount, (index) {
      final x = index % cols;
      final y = index ~/ cols;
      return Cell(x, y, cellSize, visited: index == 0);
    });
    _currentCellIndex = 0;
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

  void _restart() {
    if (_ticker.isActive) {
      _ticker.stop(canceled: true);
    }
    _elapsed = Duration.zero;
    _lastElapsed = null;
    _initCells();
    _ticker.start();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _initCells();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.grey.shade200,
              ),
              child: SizedBox(
                width: mazeSize,
                height: mazeSize,
                child: CustomPaint(
                  painter: MazePainter(
                    cells: cells,
                    currentCellIndex: _currentCellIndex,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _toggle,
                icon: Icon(
                  _ticker.isActive ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: _restart,
                icon: const Icon(
                  Icons.restart_alt_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MazePainter extends CustomPainter {
  MazePainter({required this.cells, required this.currentCellIndex});

  final List<Cell> cells;
  final int currentCellIndex;

  @override
  void paint(Canvas canvas, Size size) {
    log('rows: $rows, cols: $cols, cellCount: $cellCount');

    for (final (index, cell) in cells.indexed) {
      cell.paint(canvas);
      if (index == currentCellIndex) {
        cell.highlight(canvas);
      }
      paintText(
        canvas,
        cell.w,
        text: '${cell.x}, ${cell.y}',
        offset: cell.offset + const Offset(2, 2),
      );
      paintText(
        canvas,
        cell.w,
        text: '(${indexByCoords(cell.x, cell.y, cols, rows)})',
        offset: cell.offset + const Offset(20, 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MazePainter oldDelegate) {
    return oldDelegate.currentCellIndex != currentCellIndex ||
        oldDelegate.cells != cells;
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:app/models/graph.dart';

import '../utils.dart';
import 'node.dart';

class GraphBuilder {
  GraphBuilder({
    required this.mode,
    required this.size,
    required this.cellSize,
    this.nodesCount = 10,
    this.hasDiagonalEdges = false,
    Random? random,
  }) : _random = random ?? Random();

  final GraphMode mode;
  final Size size;
  final Size cellSize;
  final int nodesCount;
  final bool hasDiagonalEdges;

  final Random _random;

  List<Node> generateNodes() {
    late List<Offset> offsets;
    if (mode == GraphMode.grid) {
      offsets = generateGridPoints(
        canvasSize: size,
        cellSize: cellSize,
      );
    } else if (mode == GraphMode.circle) {
      offsets = generateCircularOffsets(
        radius: size.shortestSide / 2,
        center: size.center(Offset.zero),
        count: nodesCount,
      );
    } else {
      offsets = generateRandomPoints(
        random: _random,
        canvasSize: size,
        pointsCount: nodesCount,
      );
    }
    return offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
  }

  List<List<int>> generateEdges(List<Node> nodes) {
    var edges = <List<int>>[];
    if (mode == GraphMode.grid) {
      edges = generateGridEdges(
        size,
        cellSize,
        withDiagonals: hasDiagonalEdges,
      );
    } else if (mode == GraphMode.circle) {
      edges = [
        for (int i = 0; i < nodes.length; i++)
          for (int j = i + 1; j < nodes.length; j++) [i, j],
      ];
    } else {
      edges = generateRandomEdges(nodes);
    }
    return edges;
  }
}

List<List<int>> generateRandomEdges(List<Node> nodes) {
  final n = nodes.length;
  if (n <= 1) return <List<int>>[];

  final rand = Random();
  final edges = <List<int>>[];
  final seen = <String>{}; // undirected edge key: "min-max"

  void addEdge(int a, int b) {
    if (a == b) return;
    final u = a < b ? a : b;
    final v = a < b ? b : a;
    final key = '$u-$v';
    if (seen.add(key)) {
      edges.add([u, v]);
    }
  }

  // 1) Random spanning tree (guarantees connectivity).
  // Shuffle node indices, then connect each new node to a random earlier one.
  final order = List<int>.generate(n, (i) => i)..shuffle(rand);
  for (var i = 1; i < n; i++) {
    final v = order[i];
    final parent = order[rand.nextInt(i)]; // connect to any already-seen node
    addEdge(v, parent);
  }

  // 2) Extra random edges to create cycles / multiple paths.
  // Feel free to tune this multiplier for denser/sparser graphs.
  final targetExtra = max(1, (n * 0.5).round()); // ~50% more edges than a tree
  var added = 0;
  while (added < targetExtra) {
    final a = rand.nextInt(n);
    final b = rand.nextInt(n);
    // addEdge handles self-loops & duplicates
    final before = seen.length;
    addEdge(a, b);
    if (seen.length > before) added++;
  }

  return edges;
}

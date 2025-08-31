import 'package:app/models/graph.dart';

import '../utils.dart';
import 'algorithms.dart';

class AStar extends GraphAlgorithm {
  AStar(
    super.graph, {
    super.randomized,
    super.startingNodeIndex,
  });

  // Set this for a proper heuristic target.
  // If left null, we fall back to Dijkstra (h = 0)
  int? goalNodeIndex;

  // Internal A* state
  final Map<int, double> gScores = {};
  final Map<int, double> fScores = {};

  // final Set<int> closedSet = {};

  double _dist(int a, int b) {
    final na = graph.nodes[a];
    final nb = graph.nodes[b];
    final dx = na.x - nb.x;
    final dy = na.y - nb.y;
    return dx.abs() + dy.abs();
  }

  double _heuristic(int i) {
    final g = goalNodeIndex;
    if (g == null) return 0; // Dijkstra fallback if goal unknown
    return _dist(i, g);
  }

  @override
  List<int>? findStep(int targetNodeIndex) {
    if (activeNodeIndex < 0) return null;

    if (activeNodeIndex == targetNodeIndex) {
      // Found!
      activeNodeIndex = -1;
      return generatePathFromParents(
        graph.nodes,
        startingNodeIndex ?? 0,
        targetNodeIndex,
      );
    }

    goalNodeIndex = targetNodeIndex;
    step();
    return null;
  }

  @override
  bool step() {
    // 1) Seed the open set (memory) with the starting node.
    if (memory.isEmpty) {
      memory.add(activeNodeIndex);
      gScores[activeNodeIndex] = 0;
      fScores[activeNodeIndex] = _heuristic(activeNodeIndex);
    }

    // 2) Pick node from open set with the lowest f = g + h
    var bestPos = 0;
    var bestF = double.infinity;
    for (var i = 0; i < memory.length; i++) {
      final idx = memory[i];
      final f = fScores[idx] ?? double.infinity;
      if (f < bestF) {
        bestF = f;
        bestPos = i;
      } else if (f == bestF) {
        bestPos = i;
      }
    }

    activeNodeIndex = memory.removeAt(bestPos);
    graph.nodes[activeNodeIndex] = graph.nodes[activeNodeIndex].copyWith(
      isVisited: true,
    );

    // 4) Expand neighbors
    final neighbors = graph.adjacencyList[activeNodeIndex];
    for (final neighbor in neighbors) {
      if (graph.nodes[neighbor].isVisited) continue;

      final tentativeG =
          (gScores[activeNodeIndex] ?? double.infinity) +
          _dist(activeNodeIndex, neighbor);
      final knownG = gScores[neighbor] ?? double.infinity;

      if (tentativeG < knownG) {
        gScores[neighbor] = tentativeG;
        fScores[neighbor] = tentativeG + _heuristic(neighbor);

        // Track the tree using previousNode like DFS/BFS for path reconstruction
        graph.nodes[neighbor] = graph.nodes[neighbor].copyWith(
          previousNode: graph.nodes[activeNodeIndex],
        );

        if (!memory.contains(neighbor)) {
          memory.add(neighbor);
        }
      }
    }

    // 5) Done if open set is empty
    if (memory.isEmpty) {
      activeNodeIndex = -1;
      return true;
    }

    return false;
  }

  @override
  Graph execute() {
    throw UnimplementedError();
  }
}

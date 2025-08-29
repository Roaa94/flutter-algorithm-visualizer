import 'dart:math';

import 'package:app/models/algorithms.dart';

class DFS extends Algorithm {
  DFS(
    super.graph, {
    super.randomized,
    Random? random,
  }) : _random = random ?? Random();

  late final Random _random;

  @override
  bool step() {
    if (activeNodeIndex < 0) return true;
    graph.nodes[activeNodeIndex] = graph.nodes[activeNodeIndex].copyWith(
      isVisited: true,
    );
    final nextIndex = randomized
        ? graph.getRandomUnvisitedNeighbor(activeNodeIndex, _random)
        : graph.getNextUnvisitedNeighbor(activeNodeIndex);
    if (nextIndex >= 0) {
      // There are still unvisited neighbors
      graph.nodes[nextIndex] = graph.nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: graph.nodes[activeNodeIndex],
      );
      stack.add(activeNodeIndex);
      activeNodeIndex = nextIndex;
    } else if (stack.isNotEmpty) {
      // No neighbors left to visit
      activeNodeIndex = stack.removeLast();
    } else {
      // DFS completed
      activeNodeIndex = -1;
      return true;
    }
    return false;
  }
}

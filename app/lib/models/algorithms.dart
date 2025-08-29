import 'dart:math';

import 'graph_.dart';

enum GraphTraversalAlgorithm {
  dfs('DFS'),
  bfs('BFS');

  const GraphTraversalAlgorithm(this.label);

  final String label;

  Algorithm getAlgorithm(Graph graph, {bool randomized = true}) {
    switch (this) {
      case dfs:
        return DFS(graph, randomized: randomized);
      case bfs:
        return BFS(graph, randomized: randomized);
    }
  }
}

enum MazeGenerationAlgorithm {
  dfs('DFS');

  const MazeGenerationAlgorithm(this.label);

  final String label;
}

abstract class Algorithm {
  Algorithm(
    this.graph, {
    this.randomized = true,
  });

  Graph graph;
  final bool randomized;
  List<int> stack = [];
  int activeNodeIndex = 0;

  bool step();
}

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

class BFS extends Algorithm {
  BFS(
    super.graph, {
    super.randomized,
    Random? random,
  }) : _random = random ?? Random();

  late final Random _random;

  @override
  bool step() {
    if (activeNodeIndex < 0) return true;

    // Seed the queue with the starting node once.
    if (stack.isEmpty) {
      stack.add(activeNodeIndex);
      // Mark the start visited so it won’t be re-enqueued.
      graph.nodes[activeNodeIndex] = graph.nodes[activeNodeIndex].copyWith(
        isVisited: true,
      );
    }

    // Always work from the queue front.
    final currentIndex = stack.first;

    // Try to expand one new neighbor per step.
    final nextIndex = randomized
        ? graph.getRandomUnvisitedNeighbor(currentIndex, _random)
        : graph.getNextUnvisitedNeighbor(currentIndex);
    if (nextIndex >= 0) {
      // Visit & enqueue that neighbor.
      graph.nodes[nextIndex] = graph.nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: graph.nodes[currentIndex],
      );
      stack.add(nextIndex);

      // For visualization, highlight the newly discovered node.
      activeNodeIndex = nextIndex;
    } else {
      // No more neighbors for this node: dequeue it.
      stack.removeAt(0);
      if (stack.isNotEmpty) {
        // Highlight the next frontier node.
        activeNodeIndex = stack.first;
      } else {
        // BFS finished.
        activeNodeIndex = -1;
        return true;
      }
    }
    return false;
  }
}

import 'package:app/models/bfs.dart';
import 'package:app/models/dfs.dart';

import '../utils.dart';
import 'graph.dart';

abstract class AlgorithmType {
  const AlgorithmType(this.label);

  final String label;

  GraphAlgorithm getAlgorithm(Graph graph, {bool randomized = true});
}

enum AlgorithmMemoryType {
  stack('Stack'),
  queue('Queue'),
  openSet('Open Set');

  const AlgorithmMemoryType(this.label);

  final String label;
}

enum GraphTraversalAlgorithmType implements AlgorithmType {
  dfs('DFS'),
  bfs('BFS');

  const GraphTraversalAlgorithmType(this.label);

  @override
  final String label;

  @override
  GraphAlgorithm getAlgorithm(Graph graph, {bool randomized = true}) {
    switch (this) {
      case dfs:
        return DFS(graph, randomized: randomized);
      case bfs:
        return BFS(graph, randomized: false);
    }
  }

  AlgorithmMemoryType get memory {
    switch (this) {
      case dfs:
        return AlgorithmMemoryType.stack;
      case bfs:
        return AlgorithmMemoryType.queue;
    }
  }
}

enum MazeGenerationAlgorithmType implements AlgorithmType {
  dfs('DFS');

  const MazeGenerationAlgorithmType(this.label);

  @override
  final String label;

  @override
  GraphAlgorithm getAlgorithm(Graph graph, {bool randomized = true}) {
    switch (this) {
      case dfs:
        return DFS(graph, randomized: randomized);
    }
  }
}

enum MazeSolvingAlgorithmType implements AlgorithmType {
  dfs('DFS'),
  bfs('BFS');

  const MazeSolvingAlgorithmType(this.label);

  @override
  final String label;

  @override
  GraphAlgorithm getAlgorithm(
    Graph graph, {
    bool randomized = false,
    int? startingNodeIndex,
  }) {
    switch (this) {
      case dfs:
        return DFS(
          graph,
          randomized: randomized,
          startingNodeIndex: startingNodeIndex,
        );
      case bfs:
        return BFS(
          graph,
          randomized: randomized,
          startingNodeIndex: startingNodeIndex,
        );
    }
  }
}

abstract class GraphAlgorithm {
  GraphAlgorithm(
    this.graph, {
    this.randomized = true,
    this.startingNodeIndex = 0,
  }) : activeNodeIndex = startingNodeIndex ?? 0;

  Graph graph;
  final bool randomized;
  final int? startingNodeIndex;

  late int activeNodeIndex;

  // Array of node indices stored by the algorithm
  // For DFS => stack
  // For BFS => queue
  // For A* => openSet
  List<int> memory = [];

  bool traverseStep() {
    if (activeNodeIndex < 0) return true;

    return step();
  }

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

    step();
    return null;
  }

  bool step();

  Graph execute();
}

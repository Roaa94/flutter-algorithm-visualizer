import 'package:app/models/a_star.dart';
import 'package:app/models/bfs.dart';
import 'package:app/models/dfs.dart';

import '../utils.dart';
import 'graph.dart';

enum AlgorithmType {
  dfs('DFS'),
  bfs('BFS'),
  aStar('A*');

  const AlgorithmType(this.label);

  final String label;

  List<AlgorithmType> get graphTraversal => [
    dfs,
    bfs,
    aStar,
  ];

  List<AlgorithmType> get mazeGeneration => [
    dfs,
  ];

  List<AlgorithmType> get mazeSolving => [
    dfs,
    bfs,
    aStar,
  ];

  GraphAlgorithm getAlgorithm(
    Graph graph, {
    bool randomized = true,
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
          randomized: false,
          startingNodeIndex: startingNodeIndex,
        );
      case aStar:
        return AStar(graph);
    }
  }

  AlgorithmMemoryType get memory {
    switch (this) {
      case dfs:
        return AlgorithmMemoryType.stack;
      case bfs:
        return AlgorithmMemoryType.queue;
      case aStar:
        return AlgorithmMemoryType.openSet;
    }
  }
}

enum AlgorithmMemoryType {
  stack('Stack'),
  queue('Queue'),
  openSet('Open Set');

  const AlgorithmMemoryType(this.label);

  final String label;
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
  // For A* => openSet / priority queue
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

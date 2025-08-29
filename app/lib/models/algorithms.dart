import 'package:app/models/bfs.dart';
import 'package:app/models/dfs.dart';

import 'graph.dart';

abstract class AlgorithmType {
  const AlgorithmType(this.label);

  final String label;

  GraphAlgorithm getAlgorithm(Graph graph, {bool randomized = true});
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
        return BFS(graph, randomized: randomized);
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
  GraphAlgorithm getAlgorithm(Graph graph, {bool randomized = true}) {
    switch (this) {
      case dfs:
        return DFS(graph, randomized: randomized);
      case bfs:
        return BFS(graph, randomized: randomized);
    }
  }
}

abstract class GraphAlgorithm {
  GraphAlgorithm(
    this.graph, {
    this.randomized = true,
  });

  Graph graph;
  final bool randomized;
  List<int> stack = [];
  int activeNodeIndex = 0;

  bool traverseStep() {
    if (activeNodeIndex < 0) return true;

    return step();
  }

  bool findStep(int targetNodeIndex) {
    if (activeNodeIndex < 0) return true;

    if (activeNodeIndex == targetNodeIndex) {
      // Found!
      activeNodeIndex = -1;
      return true;
    }

    return step();
  }

  bool step();

  Graph execute();
}

import 'package:app/models/bfs.dart';
import 'package:app/models/dfs.dart';

import 'graph.dart';

abstract class AlgorithmType {
  const AlgorithmType(this.label);

  final String label;

  Algorithm getAlgorithm(Graph graph, {bool randomized = true});
}

enum GraphTraversalAlgorithmType implements AlgorithmType {
  dfs('DFS'),
  bfs('BFS');

  const GraphTraversalAlgorithmType(this.label);

  @override
  final String label;

  @override
  Algorithm getAlgorithm(Graph graph, {bool randomized = true}) {
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
  Algorithm getAlgorithm(Graph graph, {bool randomized = true}) {
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
  Algorithm getAlgorithm(Graph graph, {bool randomized = true}) {
    switch (this) {
      case dfs:
        return DFS(graph, randomized: randomized);
      case bfs:
        return BFS(graph, randomized: randomized);
    }
  }
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

  bool traverseStep();

  bool findStep(int targetNodeIndex);

  Graph execute();
}

import 'package:app/models/bfs.dart';
import 'package:app/models/dfs.dart';

import 'graph.dart';

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

  Algorithm getAlgorithm(Graph graph, {bool randomized = true}) {
    switch (this) {
      case dfs:
        return DFS(graph, randomized: randomized);
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

  bool step();
}

enum GraphTraversalAlgorithm {
  dfs('DFS'),
  bfs('BFS');

  const GraphTraversalAlgorithm(this.label);

  final String label;
}

enum MazeGenerationAlgorithm {
  dfs('DFS');

  const MazeGenerationAlgorithm(this.label);

  final String label;
}

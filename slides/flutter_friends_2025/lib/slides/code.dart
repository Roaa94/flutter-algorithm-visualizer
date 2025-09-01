const graphRepresentationCode1 = '''
// A list of all the edges in the graph
final List<List<int>> edges = [
  [0, 2],
  [0, 3],
  [0, 4],
  [2, 3],
];

// The adjacency list
final List<List<int>> adjacencyList = [
  [2, 4, 3], // Neighbors of node 0
  [0, 2, 3, 5], // Neighbors of node 1
];''';

const graphRepresentationCode2 = '''
class Graph {
  List<Node> nodes;
  List<List<int>> edges;
  List<List<int>> adjacencyList;
  //... 
}

class Node {
  final double x;
  final double y;
  final bool isVisited;
  final Node? previousNode;
  //...
}''';

const graphPaintingCode1 = '''
// Paint nodes
for (final node in graph.nodes) {
  canvas.drawCircle(
    node.offset,
    nodeRadius,
    nodePaint,
  );
}''';

const graphPaintingCode2 = '''
// Paint edges
for (final edge in graph.edges) {
  final start = graph.nodes[edge.first];
  final end = graph.nodes[edge.last];

  canvas.drawLine(
    start.offset,
    end.offset,
    paint,
  );
}''';

const graphPaintingCode3 = '''
// Paint arrows
for (final node in graph.nodes) {
  if (node.previousNode != null) {
    // Draw arrow from previous to current node
    paintArrow(
      canvas,
      node.previousNode!.offset,
      node.offset,
      //...
    );
  }
}''';

const dfsPseudoCode = '''
DFS(start):
    create an empty stack
    push start node onto stack
    mark start as visited

    while stack is not empty:
        current = stack.pop()
        visit(current)

        for each neighbor of current:
            if neighbor is not visited:
                mark neighbor as visited
                push neighbor onto stack''';
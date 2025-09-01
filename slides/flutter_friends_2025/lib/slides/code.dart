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

const simulationCodeAbstractAlgorithm = '''
abstract class Algorithm {
  Graph graph;

  List<int> stack = [];
  int activeNodeIndex;
  
  // Incrementally update algorithm state 
  void step();
}''';

const simulationCodeTickerSetUp1 = '''
class _SimulationWidgetState extends State<SimulationWidget>
    with SingleTickerProviderStateMixin {
    
    late final Ticker _ticker;

    @override
    void initState() {
      super.initState();
      _ticker = createTicker(_onTick);
    }
}''';

const simulationCodeTickerSetUp2 = '''
class _SimulationWidgetState extends State<SimulationWidget>
    with SingleTickerProviderStateMixin {
    
    late final Ticker _ticker;
    
    void _onTick(Duration elapsed) {
      _algorithm.step();
      setState(() => {});
    }

    @override
    void initState() {
      super.initState();
      _ticker = createTicker(_onTick);
    }
}''';

const bfsPseudoCode = '''
BFS(start):
    create an empty queue
    enqueue start node
    mark start as visited

    while queue is not empty:
        current = queue.dequeue()
        visit(current)

        for each neighbor of current:
            if neighbor is not visited:
                mark neighbor as visited
                enqueue neighbor
''';

const algorithmFindStepCode1 = '''
abstract class Algorithm {
  //...
  int activeNodeIndex;
  
  void step();
  
  List<int>? findStep({int targetNodeIndex}) {
    
    
    
    

    
    
  }
}''';

const algorithmFindStepCode2 = '''
abstract class Algorithm {
  //...
  int activeNodeIndex;
  
  void step();
  
  List<int>? findStep({int targetNodeIndex}) {
    if (activeNodeIndex == targetNodeIndex) {
      // Found!
      return generatePathFromParents(graph.nodes, 0, targetNodeIndex);
    }

    step();
    return null;
  }
}''';
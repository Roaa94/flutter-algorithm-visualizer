import 'dart:math';

import 'package:app/models/algorithms.dart';
import 'package:app/models/graph.dart';
import 'package:app/models/node.dart';
import 'package:app/utils.dart';

class DFS extends GraphAlgorithm {
  DFS(
    super.graph, {
    super.randomized,
    super.startingNodeIndex,
    Random? random,
  }) : _random = random ?? Random();

  late final Random _random;

  @override
  bool step() {
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

  @override
  Graph execute() {
    final stackLocal = <int>[0];

    while (stackLocal.isNotEmpty) {
      final v = stackLocal.removeLast();

      // Skip if already visited (could have been pushed multiple times).
      if (graph.nodes[v].isVisited) continue;

      // Visit v.
      graph.nodes[v] = graph.nodes[v].copyWith(isVisited: true);

      // Get neighbors (deterministic order or randomized).
      final neighbors = List<int>.from(graph.adjacencyList[v]);
      if (randomized) {
        neighbors.shuffle(_random);
      }

      // Discover neighbors: set previousNode on first discovery and push them.
      // Push in reverse so the first neighbor is processed next (LIFO).
      for (final n in neighbors.reversed) {
        if (!graph.nodes[n].isVisited) {
          // set tree-parent only once (on discovery)
          graph.nodes[n] = graph.nodes[n].copyWith(
            previousNode: graph.nodes[v],
          );
          stackLocal.add(n);
        }
      }
    }

    final dfsEdges = generateEdgesFromNodeParents(graph.nodes);
    final dfsNodes = List<Node>.from(
      graph.nodes.map(
        (node) => Node(node.x, node.y),
      ),
    );
    final dfsGraph = Graph(nodes: dfsNodes, edges: dfsEdges);
    return dfsGraph;
  }
}

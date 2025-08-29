import 'dart:math';

import 'package:app/models/graph.dart';

import 'algorithms.dart';

class BFS extends GraphAlgorithm {
  BFS(
    super.graph, {
    super.randomized,
    super.startingNodeIndex,
    Random? random,
  }) : _random = random ?? Random();

  late final Random _random;

  @override
  bool step({int? targetNodeIndex}) {
    // Seed the queue with the starting node once.
    if (memory.isEmpty) {
      memory.add(activeNodeIndex);
      // Mark the start visited so it won’t be re-enqueued.
      graph.nodes[activeNodeIndex] = graph.nodes[activeNodeIndex].copyWith(
        isVisited: true,
      );
    }

    // Always work from the queue front.
    activeNodeIndex = memory.first;
    // Try to expand one new neighbor per step.
    final nextIndex = randomized
        ? graph.getRandomUnvisitedNeighbor(activeNodeIndex, _random)
        : graph.getNextUnvisitedNeighbor(activeNodeIndex);
    if (nextIndex >= 0) {
      // Visit & enqueue that neighbor.
      graph.nodes[nextIndex] = graph.nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: graph.nodes[activeNodeIndex],
      );
      memory.add(nextIndex);

      // For visualization, highlight the newly discovered node.
      activeNodeIndex = nextIndex;
    } else if (memory.isNotEmpty) {
      // No more neighbors for this node: dequeue it.
      memory.removeAt(0);
    } else {
      // BFS finished.
      activeNodeIndex = -1;
      return true;
    }
    return false;
  }

  @override
  Graph execute() {
    // TODO: implement execute
    throw UnimplementedError();
  }
}

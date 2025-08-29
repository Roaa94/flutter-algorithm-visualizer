import 'dart:math';

import 'package:app/models/graph.dart';

import 'algorithms.dart';

class AStar extends GraphAlgorithm {
  AStar(
    super.graph, {
      super.randomized,
    super.startingNodeIndex,
    Random? random,
  }) : _random = random ?? Random();

  late final Random _random;

  @override
  bool step() {
    //
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

    if(memory.isNotEmpty) {

    } else {
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

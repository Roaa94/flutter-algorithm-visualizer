import 'dart:math';

import 'package:app/models/graph.dart';

import 'algorithms.dart';

class BFS extends Algorithm {
  BFS(
    super.graph, {
    super.randomized,
    Random? random,
  }) : _random = random ?? Random();

  late final Random _random;

  @override
  bool traverseStep() {
    if (activeNodeIndex < 0) return true;

    // Seed the queue with the starting node once.
    if (stack.isEmpty) {
      stack.add(activeNodeIndex);
      // Mark the start visited so it won’t be re-enqueued.
      graph.nodes[activeNodeIndex] = graph.nodes[activeNodeIndex].copyWith(
        isVisited: true,
      );
    }

    // Always work from the queue front.
    final currentIndex = stack.first;

    // Try to expand one new neighbor per step.
    final nextIndex = randomized
        ? graph.getRandomUnvisitedNeighbor(currentIndex, _random)
        : graph.getNextUnvisitedNeighbor(currentIndex);
    if (nextIndex >= 0) {
      // Visit & enqueue that neighbor.
      graph.nodes[nextIndex] = graph.nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: graph.nodes[currentIndex],
      );
      stack.add(nextIndex);

      // For visualization, highlight the newly discovered node.
      activeNodeIndex = nextIndex;
    } else {
      // No more neighbors for this node: dequeue it.
      stack.removeAt(0);
      if (stack.isNotEmpty) {
        // Highlight the next frontier node.
        activeNodeIndex = stack.first;
      } else {
        // BFS finished.
        activeNodeIndex = -1;
        return true;
      }
    }
    return false;
  }

  @override
  bool findStep(int targetNodeIndex) {
    if (activeNodeIndex < 0) return true;

    if (activeNodeIndex == targetNodeIndex) {
      // Found!
      activeNodeIndex = -1;
      return true;
    }

    // Seed the queue with the starting node once.
    if (stack.isEmpty) {
      stack.add(activeNodeIndex);
      // Mark the start visited so it won’t be re-enqueued.
      graph.nodes[activeNodeIndex] = graph.nodes[activeNodeIndex].copyWith(
        isVisited: true,
      );
    }

    // Always work from the queue front.
    final currentIndex = stack.first;

    // Try to expand one new neighbor per step.
    final nextIndex = randomized
        ? graph.getRandomUnvisitedNeighbor(currentIndex, _random)
        : graph.getNextUnvisitedNeighbor(currentIndex);
    if (nextIndex >= 0) {
      // Visit & enqueue that neighbor.
      graph.nodes[nextIndex] = graph.nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: graph.nodes[currentIndex],
      );
      stack.add(nextIndex);

      // For visualization, highlight the newly discovered node.
      activeNodeIndex = nextIndex;
    } else {
      // No more neighbors for this node: dequeue it.
      stack.removeAt(0);
      if (stack.isNotEmpty) {
        // Highlight the next frontier node.
        activeNodeIndex = stack.first;
      } else {
        // BFS finished.
        activeNodeIndex = -1;
        return true;
      }
    }
    return false;
  }

  @override
  Graph execute() {
    // TODO: implement execute
    throw UnimplementedError();
  }
}

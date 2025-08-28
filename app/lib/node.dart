import 'dart:ui';

import 'package:equatable/equatable.dart';

class Node extends Equatable {
  const Node(
    this.x,
    this.y, {
    this.isVisited = false,
    this.previousNode,
  });

  final double x;
  final double y;
  final bool isVisited;
  final Node? previousNode;

  Offset get offset => Offset(x, y);

  Node copyWith({
    double? x,
    double? y,
    bool? isVisited,
    Node? previousNode,
  }) {
    return Node(
      x ?? this.x,
      y ?? this.y,
      isVisited: isVisited ?? this.isVisited,
      previousNode: previousNode ?? this.previousNode,
    );
  }

  @override
  List<Object?> get props => [
    x,
    y,
    isVisited,
  ];
}

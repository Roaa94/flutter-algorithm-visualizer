import 'dart:ui';

import 'package:equatable/equatable.dart';

class Node extends Equatable {
  const Node(
    this.x,
    this.y, {
    this.isVisited = false,
  });

  final double x;
  final double y;
  final bool isVisited;

  Offset get offset => Offset(x, y);

  Node copyWith({
    double? x,
    double? y,
    bool? isVisited,
  }) {
    return Node(
      x ?? this.x,
      y ?? this.y,
      isVisited: isVisited ?? this.isVisited,
    );
  }

  @override
  List<Object?> get props => [
    x,
    y,
    isVisited,
  ];
}

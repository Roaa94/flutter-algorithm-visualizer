import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_grid_demo.dart';
import 'package:flutter_friends_2025/demos/dfs_maze_demo.dart';
import 'package:flutter_friends_2025/demos/bfs_maze_solving_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class BFSMazeSolvingDemoSlide extends FlutterDeckSlideWidget {
  const BFSMazeSolvingDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/bfs-maze-solving-demo',
          title: 'BFS Maze Solving Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      content: const BFSMazeSolvingDemo(),
    );
  }
}

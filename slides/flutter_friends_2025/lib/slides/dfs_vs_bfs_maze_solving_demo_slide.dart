import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_vs_bfs_demo.dart';
import 'package:flutter_friends_2025/demos/dfs_vs_bfs_maze_solving_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class DFSvsBFSMazeSolvingDemoSlide extends FlutterDeckSlideWidget {
  const DFSvsBFSMazeSolvingDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dfs-vs-bfs-maze-solving-demo',
          title: 'DFS vs. BFS Maze Solving Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'DFS vs. BFS Maze Solving',
      showHeader: true,
      content: const DFSvsBFSMazeSolvingDemo(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_maze_solving_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class DFSMazeSolvingDemoSlide extends FlutterDeckSlideWidget {
  const DFSMazeSolvingDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dfs-maze-solving-demo',
          title: 'DFS Maze Solving Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      content: const DFSMazeSolvingDemo(),
    );
  }
}

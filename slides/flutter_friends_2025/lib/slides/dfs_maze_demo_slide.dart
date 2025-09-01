import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_grid_demo.dart';
import 'package:flutter_friends_2025/demos/dfs_maze_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class DFSMazeDemoSlide extends FlutterDeckSlideWidget {
  const DFSMazeDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dfs-maze-demo',
          title: 'DFS Maze Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      content: const DFSMazeDemo(),
    );
  }
}

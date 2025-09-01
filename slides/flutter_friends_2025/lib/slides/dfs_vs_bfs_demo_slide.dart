import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_vs_bfs_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class DFSvsBFSDemoSlide extends FlutterDeckSlideWidget {
  const DFSvsBFSDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dfs-vs-bfs-demo',
          title: 'DFS vs. BFS Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'DFS vs. BFS',
      showHeader: true,
      content: const DFSvsBFSDemo(),
    );
  }
}

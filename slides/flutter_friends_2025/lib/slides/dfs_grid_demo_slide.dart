import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_grid_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class DFSGridDemoSlide extends FlutterDeckSlideWidget {
  const DFSGridDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dfs-grid-demo',
          title: 'DFS Grid Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      content: const DFSGridDemo(),
    );
  }
}

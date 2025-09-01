import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/bfs_demo.dart';
import 'package:flutter_friends_2025/demos/dfs_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class BFSDemoSlide extends FlutterDeckSlideWidget {
  const BFSDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/bfs-demo',
          title: 'BFS Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'BFS Algorithm',
      showHeader: true,
      content: const BFSDemo(),
    );
  }
}

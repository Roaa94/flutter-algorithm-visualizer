import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/demos/dfs_demo.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class DFSDemoSlide extends FlutterDeckSlideWidget {
  const DFSDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dfs-demo',
          title: 'DFS Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'DFS Algorithm',
      showHeader: true,
      content: const DFSDemo(),
    );
  }
}

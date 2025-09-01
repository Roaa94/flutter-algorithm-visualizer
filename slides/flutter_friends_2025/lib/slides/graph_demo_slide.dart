import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';
import 'package:flutter_friends_2025/widgets/window_frame.dart';

class GraphDemoSlide extends FlutterDeckSlideWidget {
  const GraphDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/graph-demo',
          title: 'Graph Demo',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      content: WindowFrame(
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        label: 'Graph',
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.black,
          child: SizedBox.expand(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GraphTraversalDemo(
                  size: constraints.biggest,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/styles/text_styles.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class RecapSlides extends FlutterDeckSlideWidget {
  const RecapSlides({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/recap',
          title: 'Topics Covered',
        ),
      );

  static const steps = [
    'Recap',
  ];

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Topics Explored',
      showHeader: true,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: List.generate(
            steps.length,
            (i) => Text(
              'ℹ️ ${steps[i]}',
              style: TextStyles.subtitleSM,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}

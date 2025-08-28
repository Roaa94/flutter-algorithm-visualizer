import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/styles/text_styles.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class AgendaSlide extends FlutterDeckSlideWidget {
  AgendaSlide({super.key, this.step = 1, this.completed = 0, this.route})
    : super(
        configuration: FlutterDeckSlideConfiguration(
          route: route != null ? '/$route' : '/agenda-$step-$completed',
          title: 'Goals',
        ),
      );

  final int step;
  final int completed;
  final String? route;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Goals',
      showHeader: true,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: step >= 1 ? 1 : 0,
              child: Text(
                '${completed >= 1 ? '✅' : '☑️'} Step 1',
                style: TextStyles.subtitleSM,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 50),
            Opacity(
              opacity: step >= 2 ? 1 : 0,
              child: Text(
                '${completed >= 2 ? '✅' : '☑️'} Step 2',
                style: TextStyles.subtitleSM,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 50),
            Opacity(
              opacity: step >= 3 ? 1 : 0,
              child: Text(
                '${completed >= 3 ? '✅' : '☑️'} Step 3',
                style: TextStyles.subtitleSM,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

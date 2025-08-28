import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class BoilerplateSlide extends FlutterDeckSlideWidget {
  BoilerplateSlide({super.key})
    : super(
        configuration: FlutterDeckSlideConfiguration(
          route: '',
          title: '',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
    );
  }
}

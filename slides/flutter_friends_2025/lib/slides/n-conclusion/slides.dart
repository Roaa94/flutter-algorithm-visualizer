import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/slides/n-conclusion/recap_slide.dart';
import 'package:flutter_friends_2025/templates/section_title_slide.dart';

final conclusionSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide(
    'Conclusion',
    route: 'conclusion-section-title-route',
  ),
  const RecapSlides(),
  SectionTitleSlide(
    'Thank you!',
    route: 'last',
  ),
];

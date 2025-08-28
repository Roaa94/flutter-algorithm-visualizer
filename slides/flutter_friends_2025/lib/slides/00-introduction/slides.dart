import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/slides/00-introduction/agenda_slide.dart';

import '../../templates/section_title_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide(
    'Intro',
    route: 'intro-section-title-route',
  ),
  // ImageSlide(
  //   title: '',
  //   path: 'assets/images/image.png',
  //   route: 'image-slide-route',
  //   width: 1100,
  // ),
  AgendaSlide(step: 1),
  AgendaSlide(step: 2),
  AgendaSlide(step: 3),
];

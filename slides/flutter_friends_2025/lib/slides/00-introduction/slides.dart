import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/templates/image_slide.dart';

import '../../templates/section_title_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  // 1
  ImageSlide(
    title: 'The Seven Bridges of Königsberg',
    path: 'assets/images/konigsberg.png',
    route: 'city-map',
    width: 800,
  ),
  // 2
  ImageSlide(
    title: 'The Seven Bridges of Königsberg',
    path: 'assets/images/city-illustration.png',
    route: 'city-illustration',
    width: 800,
  ),
  // 3
  ImageSlide(
    title: 'The Seven Bridges of Königsberg',
    path: 'assets/images/city-illustration-with-graph.png',
    route: 'city-illustration-with-graph',
    width: 800,
  ),
  // 4
  ImageSlide(
    title: 'The Seven Bridges of Königsberg',
    path: 'assets/images/city-illustration-with-graph-degrees.png',
    route: 'city-illustration-with-graph-degrees',
    width: 800,
  ),
  // 5
  ImageSlide(
    title: 'Present State of Königsberg - Kaliningrad, Russia',
    path: 'assets/images/konigsberg-present.png',
    route: 'konigsberg-present',
    width: 700,
  ),
  SectionTitleSlide(
    'Graph Theory',
    route: 'graph-theory',
  ),
];

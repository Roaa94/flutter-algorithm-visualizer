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
    path: 'assets/images/city-illustration-with-graph-info-1.png',
    route: 'city-illustration-with-graph',
    width: 800,
  ),
  // 4
  ImageSlide(
    title: 'The Seven Bridges of Königsberg',
    path: 'assets/images/city-illustration-with-graph-info.png',
    route: 'city-illustration-with-graph-info',
    width: 800,
  ),
  // 5
  ImageSlide(
    title: 'Present State of Königsberg - Kaliningrad, Russia',
    path: 'assets/images/konigsberg-present.png',
    route: 'konigsberg-present',
    width: 700,
  ),
  // 6
  ImageSlide(
    title: 'Present State of Königsberg - Kaliningrad, Russia',
    path: 'assets/images/city-illustration-with-graph-new.png',
    route: 'konigsberg-present-graph',
    width: 700,
  ),
  // 7
  SectionTitleSlide(
    'The Geometry of Position',
    subtitle: '',
  ),
  // 8
  SectionTitleSlide(
    'The Geometry of Position',
    subtitle: 'Graph Theory',
    route: 'graph-theory',
  ),
];

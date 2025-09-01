import 'package:flutter_friends_2025/slides/code.dart';
import 'package:flutter_friends_2025/slides/dfs_demo_slide.dart';
import 'package:flutter_friends_2025/slides/graph_demo_slide.dart';
import 'package:flutter_friends_2025/slides/maze_art_demo.dart';
import 'package:flutter_friends_2025/slides/title_slide.dart';
import 'package:flutter_friends_2025/templates/code_slide.dart';
import 'package:flutter_friends_2025/templates/image_slide.dart';
import 'package:flutter_friends_2025/templates/section_title_slide.dart';

final slides = [
  const TitleSlide(),
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
  CodeSlide(
    graphRepresentationCode1,
    title: 'Graph Representation',
    route: 'graph-representation-code-1',
  ),
  CodeSlide(
    graphRepresentationCode2,
    title: 'Graph Representation',
    route: 'graph-representation-code-2',
  ),
  CodeSlide(
    graphPaintingCode1,
    title: 'Graph Painting',
    route: 'graph-painting-code-1',
  ),
  CodeSlide(
    graphPaintingCode2,
    title: 'Graph Painting',
    route: 'graph-painting-code-2',
  ),
  CodeSlide(
    graphPaintingCode3,
    title: 'Graph Painting',
    route: 'graph-painting-code-3',
  ),
  GraphDemoSlide(),
  SectionTitleSlide(
    'Graph Traversal',
  ),
  CodeSlide(
    dfsPseudoCode,
    title: 'Depth-First-Search (DFS) Algorithm',
  ),
  DFSDemoSlide(),
  MazeArtDemoSlide(),
  SectionTitleSlide(
    'Thank you!',
    route: 'last',
  ),
];

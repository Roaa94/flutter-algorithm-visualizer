import 'package:flutter_friends_2025/slides/bfs_demo_slide.dart';
import 'package:flutter_friends_2025/slides/bfs_maze_solving_demo_slide.dart';
import 'package:flutter_friends_2025/slides/code.dart';
import 'package:flutter_friends_2025/slides/dfs_demo_slide.dart';
import 'package:flutter_friends_2025/slides/dfs_grid_demo_slide.dart';
import 'package:flutter_friends_2025/slides/dfs_maze_demo_slide.dart';
import 'package:flutter_friends_2025/slides/dfs_maze_solving_demo_slide.dart';
import 'package:flutter_friends_2025/slides/dfs_vs_bfs_demo_slide.dart';
import 'package:flutter_friends_2025/slides/dfs_vs_bfs_maze_solving_demo_slide.dart';
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
    title: 'The Seven Bridges of Königsberg - 1736',
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
  ImageSlide(
    title: 'Present State of Königsberg - Kaliningrad, Russia',
    path: 'assets/images/konigsberg-present-solution.png',
    route: 'konigsberg-present-graph-solution',
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
  SectionTitleSlide(
    'Graph Representation',
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
  CodeSlide(
    graphPaintingCode4,
    title: 'Graph Painting',
    route: 'graph-painting-code-4',
  ),
  GraphDemoSlide(),
  SectionTitleSlide(
    'Graph Traversal',
  ),
  SectionTitleSlide(
    'Depth-First-Search (DFS) Algorithm',
    isSubtitle: true,
    route: 'dfs-title',
  ),
  CodeSlide(
    dfsPseudoCode,
    title: 'Depth-First-Search (DFS) Algorithm',
  ),
  DFSDemoSlide(),
  CodeSlide(
    simulationCodeAbstractAlgorithm,
    title: 'Flutter Simulation - Algorithm Interface',
  ),
  CodeSlide(
    simulationCodeDFSAlgorithmSnippet1,
    title: 'Flutter Simulation - DFS Snippet',
    route: 'dfs-code-1',
  ),
  CodeSlide(
    simulationCodeDFSAlgorithmSnippet2,
    title: 'Flutter Simulation - DFS Snippet',
    route: 'dfs-code-2',
  ),
  CodeSlide(
    simulationCodeDFSAlgorithmSnippet3,
    title: 'Flutter Simulation - DFS Snippet',
    route: 'dfs-code-3',
  ),
  CodeSlide(
    simulationCodeTickerSetUp1,
    title: 'Flutter Simulation - Ticker Setup',
    route: 'flutter-simulation-ticker-1',
  ),
  CodeSlide(
    simulationCodeTickerSetUp2,
    title: 'Flutter Simulation - Ticker Setup',
    route: 'flutter-simulation-ticker-2',
  ),
  SectionTitleSlide(
    'DFS Application',
  ),
  DFSGridDemoSlide(),
  DFSMazeDemoSlide(),
  SectionTitleSlide(
    'Breadth-First-Search (BFS) Algorithm',
    isSubtitle: true,
    route: 'bfs-title',
  ),
  CodeSlide(
    bfsPseudoCode,
    title: 'Breadth-First-Search (BFS) Algorithm',
  ),
  BFSDemoSlide(),
  SectionTitleSlide(
    'BFS vs. DFS',
    route: 'dfs-vs-bfs-title',
  ),
  DFSvsBFSDemoSlide(),
  SectionTitleSlide('BFS & DFS for Path Finding'),
  CodeSlide(
    algorithmFindStepCode1,
    title: 'Algorithm Find Step Implementation',
    route: 'algorithm-find-step-1',
  ),
  CodeSlide(
    algorithmFindStepCode2,
    title: 'Algorithm Find Step Implementation',
    route: 'algorithm-find-step-2',
  ),
  BFSMazeSolvingDemoSlide(),
  DFSMazeSolvingDemoSlide(),
  SectionTitleSlide('BFS vs. DFS for Maze Solving'),
  DFSvsBFSMazeSolvingDemoSlide(),
  SectionTitleSlide(
    'One step further...',
    route: 'maze-art',
  ),
  CodeSlide(
    hueMazeEffectCode,
    title: '',
    route: 'maze-art-code',
  ),
  MazeArtDemoSlide(),
  SectionTitleSlide(
    'Thank you!',
    route: 'last',
  ),
];

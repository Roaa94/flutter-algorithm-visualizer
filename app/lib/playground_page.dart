import 'package:app/maze_visualizer.dart';
import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MazeVisualizer(
        size: MediaQuery.sizeOf(context) * 0.7,
      ),
    );
  }
}

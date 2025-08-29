import 'package:app/playgrounds/maze_generation_playground.dart';
import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canvasSize = MediaQuery.sizeOf(context) * 0.7;
    return Scaffold(
      body: MazeGenerationPlayground(
        size: canvasSize,
      ),
    );
  }
}

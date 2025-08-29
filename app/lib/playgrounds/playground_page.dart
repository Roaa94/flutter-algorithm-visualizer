import 'package:app/playgrounds/maze_generation_playground.dart';
import 'package:app/widgets/custom_radio_group.dart';
import 'package:flutter/material.dart';

import 'graph_playground.dart';

enum Playground {
  graph('Graph'),
  mazeGeneration('Maze Generation'),
  mazeSolving('Maze Solving');

  const Playground(this.label);

  final String label;

  Widget getView(Size canvasSize) {
    switch (this) {
      case graph:
        return GraphPlayground(
          size: canvasSize,
        );
      case mazeGeneration:
        return MazeGenerationPlayground(
          size: canvasSize,
        );
      case mazeSolving:
        return MazeGenerationPlayground(
          size: canvasSize,
        );
    }
  }
}

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  Playground _selectedPlayground = Playground.graph;

  @override
  Widget build(BuildContext context) {
    final canvasSize = MediaQuery.sizeOf(context) * 0.7;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 450,
                    child: CustomRadioGroup<Playground>(
                      items: Playground.values,
                      onChanged: (p) => setState(() => _selectedPlayground = p),
                      selectedItem: _selectedPlayground,
                      labelBuilder: (p) => p.label,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _selectedPlayground.getView(canvasSize),
            ),
          ],
        ),
      ),
    );
  }
}

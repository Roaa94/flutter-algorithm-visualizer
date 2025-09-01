import 'package:app/app.dart';
import 'package:app/models/algorithms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friends_2025/demos/constants.dart';
import 'package:flutter_friends_2025/widgets/window_frame.dart';

class DFSvsBFSMazeSolvingDemo extends StatelessWidget {
  const DFSvsBFSMazeSolvingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const fps = 4;
    const startingNodeIndex = 12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            child: WindowFrame(
              label: 'DFS',
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black,
                child: SizedBox.expand(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return MazeSolvingDemo(
                        size: constraints.biggest,
                        selectedAlgorithmType: MazeSolvingAlgorithmType.dfs,
                        nodesPerCol: Constants.mazeCellColCount,
                        frameRate: 60,
                        playTrigger: true,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: WindowFrame(
              label: 'BFS',
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black,
                child: SizedBox.expand(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return MazeSolvingDemo(
                        size: constraints.biggest,
                        selectedAlgorithmType: MazeSolvingAlgorithmType.bfs,
                        nodesPerCol: Constants.mazeCellColCount,
                        frameRate: 60,
                        playTrigger: true,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

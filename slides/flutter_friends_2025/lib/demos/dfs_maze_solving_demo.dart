import 'package:app/app.dart';
import 'package:app/models/algorithms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friends_2025/demos/constants.dart';
import 'package:flutter_friends_2025/widgets/controls.dart';
import 'package:flutter_friends_2025/widgets/window_frame.dart';

class DFSMazeSolvingDemo extends StatefulWidget {
  const DFSMazeSolvingDemo({super.key});

  @override
  State<DFSMazeSolvingDemo> createState() => _DFSMazeSolvingDemoState();
}

class _DFSMazeSolvingDemoState extends State<DFSMazeSolvingDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  bool playTrigger = false;
  bool resetTrigger = false;
  bool showMazeView = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          WindowFrame(
            label: 'DFS Solver - Custom Start & End',
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black,
              child: SizedBox.expand(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return MazeSolvingDemo(
                      size: Size(
                        constraints.biggest.width,
                        constraints.biggest.height - 60,
                      ),
                      selectedAlgorithmType: MazeSolvingAlgorithmType.dfs,
                      playTrigger: playTrigger,
                      nodesPerCol: Constants.mazeCellColCount,
                      frameRate: 60,
                      resetTrigger: resetTrigger,
                      mazeView: showMazeView,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.1,
            right: 0,
            left: 0,
            child: RepaintBoundary(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  ControlsButton(
                    onTap: () => setState(() => playTrigger = !playTrigger),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: playTrigger ? Icons.pause : Icons.play_arrow,
                  ),
                  ControlsButton(
                    onTap: () {
                      setState(() {
                        resetTrigger = !resetTrigger;
                        playTrigger = !playTrigger;
                      });
                    },
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.refresh,
                  ),
                  ControlsButton(
                    onTap: () {
                      setState(() {
                        showMazeView = !showMazeView;
                      });
                    },
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: showMazeView
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

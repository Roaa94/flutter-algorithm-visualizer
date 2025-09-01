import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friends_2025/styles.dart';
import 'package:flutter_friends_2025/widgets/controls.dart';
import 'package:flutter_friends_2025/widgets/window_frame.dart';

class DFSDemo extends StatefulWidget {
  const DFSDemo({super.key});

  @override
  State<DFSDemo> createState() => _DFSDemoState();
}

class _DFSDemoState extends State<DFSDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = AppColors.primary;
  bool nextTrigger = false;
  bool playTrigger = false;
  bool resetTrigger = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          WindowFrame(
            label: 'DFS',
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black,
              child: SizedBox.expand(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GraphTraversalDemo(
                      size: Size(
                        constraints.biggest.width,
                        constraints.biggest.height - 70,
                      ),
                      playTrigger: playTrigger,
                      nodesPerCol: 3,
                      nodesPerRow: 3,
                      frameRate: 2,
                      showMemory: true,
                      resetTrigger: resetTrigger,
                      nextTrigger: nextTrigger,
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
                    onTap: () => setState(() => nextTrigger = !nextTrigger),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.skip_next,
                  ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

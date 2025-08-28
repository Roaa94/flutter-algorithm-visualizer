import 'package:flutter/material.dart';

import 'graph_visualizer.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphVisualizer(
        size: MediaQuery.sizeOf(context) * 0.7,
      ),
    );
  }
}

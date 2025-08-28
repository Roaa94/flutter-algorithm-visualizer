import 'package:app/custom_radio_group.dart';
import 'package:flutter/material.dart';

import 'graph.dart';
import 'graph_visualizer.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  GraphMode _mode = GraphMode.grid;
  bool _triggerReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GraphVisualizer(
                    size: constraints.biggest,
                    mode: _mode,
                    nodesCount: 10,
                    triggerReset: _triggerReset,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _triggerReset = !_triggerReset;
                    });
                  },
                  child: Text('Reset'),
                ),
                SizedBox(
                  width: 400,
                  child: CustomRadioGroup<GraphMode>(
                    selectedItem: _mode,
                    items: GraphMode.values,
                    onChanged: (mode) {
                      setState(() {
                        _mode = mode;
                      });
                    },
                    labelBuilder: (m) => m.label,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

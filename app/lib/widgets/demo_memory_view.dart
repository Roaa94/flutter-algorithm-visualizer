import 'package:app/models/algorithms.dart';
import 'package:flutter/material.dart';

class DemoMemoryView extends StatelessWidget {
  const DemoMemoryView({
    super.key,
    required this.algorithm,
    required this.selectedAlgorithmType,
  });

  final GraphAlgorithm algorithm;
  final AlgorithmType selectedAlgorithmType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelItem(selectedAlgorithmType.memory.label),
        Expanded(
          child: Align(
            alignment: selectedAlgorithmType.memory == AlgorithmMemoryType.stack
                ? Alignment.bottomCenter
                : Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children:
                    (selectedAlgorithmType.memory == AlgorithmMemoryType.stack
                            ? algorithm.memory.reversed
                            : algorithm.memory)
                        .map(
                          (item) => LabelItem(item.toString()),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LabelItem extends StatelessWidget {
  const LabelItem(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SliderTile extends StatelessWidget {
  const SliderTile({
    super.key,
    required this.label,
    this.value = 0,
    this.min = 0,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final num value;
  final double min;
  final double max;

  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label (${value.toStringAsFixed(2)})'),
        Flexible(
          child: Slider(
            padding: EdgeInsets.zero,
            value: value.toDouble(),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

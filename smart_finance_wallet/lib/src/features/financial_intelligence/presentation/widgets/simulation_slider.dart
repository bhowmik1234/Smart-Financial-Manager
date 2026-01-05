import 'package:flutter/material.dart';

class SimulationSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final String Function(double)? labelFormatter;

  const SimulationSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.labelFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(
              labelFormatter != null
                  ? labelFormatter!(value)
                  : value.toStringAsFixed(0),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF651FFF),
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.white,
            overlayColor: const Color(0xFF651FFF).withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

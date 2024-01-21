import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.textValue, required this.colors});

  final List<Color> colors;
  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            color: colors[0],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12,
              ),
              child: Text(
                textValue,
                style: TextStyle(color: colors[1]),
              ),
            )));
  }
}

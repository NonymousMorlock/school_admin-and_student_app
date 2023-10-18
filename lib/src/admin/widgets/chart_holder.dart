import 'package:flutter/material.dart';

class ChartHolder extends StatelessWidget {
  const ChartHolder({required this.chartSample, super.key});

  final Widget chartSample;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          const SizedBox(height: 2),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1B2339),
              borderRadius:
                  BorderRadius.all(Radius.circular(8)),
            ),
            child: chartSample,
          ),
        ],
      ),
    );
  }
}

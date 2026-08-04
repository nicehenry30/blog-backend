import 'package:flutter/material.dart';

class SignalQualityBadge extends StatelessWidget {
  final double quality;

  const SignalQualityBadge({
    super.key,
    required this.quality,
  });

  @override
  Widget build(BuildContext context) {
    int stars;

    if (quality >= 90) {
      stars = 5;
    } else if (quality >= 80) {
      stars = 4;
    } else if (quality >= 70) {
      stars = 3;
    } else if (quality >= 60) {
      stars = 2;
    } else {
      stars = 1;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < stars
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      ),
    );
  }
}
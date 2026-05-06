import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class LocationAccuracyIndicator extends StatelessWidget {
  const LocationAccuracyIndicator({
    super.key,
    required this.accuracyInMeters,
    this.showText = true,
  });

  final double accuracyInMeters;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final (color, icon, description) = _getAccuracyDetails(accuracyInMeters);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.space(factor: 2), color: color),
        if (showText) ...[
          const DSHorizontalSpacerWidget(1),
          DSTextWidget(
            description,
            style: context.typography.labelSmall,
            color: context.colorPalette.neutral.grey7,
          ),
        ],
      ],
    );
  }

  (Color, IconData, String) _getAccuracyDetails(double accuracy) {
    if (accuracy <= 5) {
      return (Colors.green, Icons.gps_fixed, 'High accuracy');
    } else if (accuracy <= 15) {
      return (Colors.orange, Icons.gps_not_fixed, 'Medium accuracy');
    } else {
      return (Colors.red, Icons.gps_off, 'Low accuracy');
    }
  }
}

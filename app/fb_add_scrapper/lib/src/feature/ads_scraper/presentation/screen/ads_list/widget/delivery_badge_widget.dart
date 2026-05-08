import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DeliveryBadgeWidget extends StatelessWidget {
  const DeliveryBadgeWidget({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? context.colorPalette.semantic.success
        : context.colorPalette.neutral.grey5;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space(factor: 0.75),
        vertical: context.space(factor: 0.25),
      ),
      decoration: BoxDecoration(
        color: color.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.dimen.radiusLevel1.value),
        border: Border.all(color: color.color.withValues(alpha: 0.4)),
      ),
      child: DSTextWidget(
        isActive ? 'Active' : 'Stopped',
        color: color,
        style: context.typography.labelSmall,
      ),
    );
  }
}

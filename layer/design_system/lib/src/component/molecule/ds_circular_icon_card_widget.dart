import 'package:design_system/src/component/atom/atom.dart';
import 'package:design_system/src/extension/build_context_extension.dart';
import 'package:design_system/src/foundation/foundation.dart';
import 'package:flutter/material.dart';

class DSCircularIconCardWidget extends StatelessWidget {
  const DSCircularIconCardWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final DSColor color;
  final DSColor backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      backgroundColor: backgroundColor,
      radius: context.dimen.radiusCircular,
      child: Padding(
        padding: EdgeInsets.all(
          context.space(factor: context.isDesktop ? 0.5 : 1),
        ),
        child: Icon(icon, size: context.iconSize, color: color.color),
      ),
    );
  }
}

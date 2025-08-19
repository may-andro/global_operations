import 'package:design_system/src/extension/build_context_extension.dart';
import 'package:flutter/material.dart';

class DSBottomSheetWidget extends StatelessWidget {
  const DSBottomSheetWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorPalette.background.primary.color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimen.radiusLevel3.value),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 2)),
        child: child,
      ),
    );
  }
}

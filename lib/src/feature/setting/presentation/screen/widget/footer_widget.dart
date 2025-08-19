import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DSTextWidget(
          context.localizations.appVersion(''),
          color: context.colorPalette.neutral.grey7,
          style: context.typography.labelSmall,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        const DSVerticalSpacerWidget(0.5),
        DSTextWidget(
          context.localizations.copyright,
          color: context.colorPalette.neutral.grey7,
          style: context.typography.labelSmall,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

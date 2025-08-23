import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (_, snapshot) {
            if (snapshot.data case final PackageInfo packageInfo when snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(left: context.space(factor: 0.25)),
                child: DSTextWidget(
                  context.localizations.appVersion(packageInfo.version),
                  color: context.colorPalette.neutral.grey7,
                  style: context.typography.labelSmall,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              );
            }
            return const SizedBox.shrink();
          },
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

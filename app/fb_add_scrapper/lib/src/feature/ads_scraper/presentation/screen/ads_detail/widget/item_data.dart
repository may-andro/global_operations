import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Simple data holder for a label/value pair used in detail rows.
sealed class AdDetailItemData {
  const AdDetailItemData(this.label);

  final String label;
}

class AdDetailTextItem extends AdDetailItemData {
  const AdDetailTextItem(super.label, this.value);

  final String? value;
}

class AdDetailListItem extends AdDetailItemData {
  const AdDetailListItem(super.label, this.values);

  final List<String?> values;
}

class AdDetailIconItem extends AdDetailItemData {
  const AdDetailIconItem(super.label, this.icons);

  final List<IconData?> icons;
}

class AdDetailChipItem extends AdDetailItemData {
  const AdDetailChipItem(super.label, this.chips);

  final List<String?> chips;
}

class AdDetailHyperlinkItem extends AdDetailItemData {
  const AdDetailHyperlinkItem(super.label, this.urls);

  final List<String?> urls;
}

class AdDetailDateItem extends AdDetailItemData {
  const AdDetailDateItem(super.label, this.dateTime);

  final String? dateTime;
}

extension AdDetailItemDataWidgetBuilder on AdDetailItemData {
  bool get isRelevant {
    return switch (this) {
      AdDetailTextItem(:final value) => value != null && value.isNotEmpty,
      AdDetailListItem(:final values) => values.nonNulls.isNotEmpty,
      AdDetailIconItem(:final icons) => icons.nonNulls.isNotEmpty,
      AdDetailChipItem(:final chips) => chips.nonNulls.isNotEmpty,
      AdDetailHyperlinkItem(:final urls) => urls.nonNulls.isNotEmpty,
      AdDetailDateItem(:final dateTime) =>
        dateTime != null && dateTime.isNotEmpty,
    };
  }

  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.space(factor: 0.75)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.space(factor: 14),
            child: DSTextWidget(
              label,
              style: context.typography.bodySmall,
              color: context.colorPalette.neutral.grey5,
            ),
          ),
          SizedBox(width: context.space()),
          Expanded(child: _buildValueWidget(context)),
        ],
      ),
    );
  }

  void copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    context.showSnackBar(
      snackBar: DSSnackBar(message: 'Copied to clipboard: $value'),
    );
  }

  Widget _buildValueWidget(BuildContext context) {
    return switch (this) {
      AdDetailTextItem(:final value) => SelectableText(
        value ?? '',
        style: context.typography.bodySmall.textStyle.copyWith(
          color: context.colorPalette.invertedBackground.onPrimary.color,
        ),
      ),
      AdDetailListItem(:final values) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.space(factor: 0.5),
        children: values.nonNulls
            .map(
              (value) => SelectableText(
                '• $value',
                style: context.typography.bodySmall.textStyle.copyWith(
                  color:
                      context.colorPalette.invertedBackground.onPrimary.color,
                ),
              ),
            )
            .toList(),
      ),
      AdDetailIconItem(:final icons) => Wrap(
        spacing: context.space(),
        children: icons
            .map(
              (icon) => FaIcon(
                icon,
                color: context.colorPalette.neutral.grey3.color,
                size: DSIconWidget.getHeight(context, DSIconSize.small),
              ),
            )
            .toList(),
      ),
      AdDetailChipItem(:final chips) => Wrap(
        spacing: context.space(factor: 0.5),
        children: chips.nonNulls
            .map(
              (chip) => DsCardWidget(
                backgroundColor: context.colorPalette.brand.secondary,
                radius: context.dimen.radiusLevel1,
                elevation: context.dimen.elevationNone,
                margin: EdgeInsets.only(bottom: context.space()),
                onTap: () => copyToClipboard(context, chip),
                child: Padding(
                  padding: EdgeInsets.all(context.space(factor: 0.5)),
                  child: DSTextWidget(
                    chip,
                    color: context.colorPalette.brand.onSecondary,
                    style: context.typography.bodySmall,
                  ),
                ),
              ),
            )
            .toList(),
      ),
      AdDetailHyperlinkItem(:final urls) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.space(factor: 0.5),
        children: urls.nonNulls
            .map(
              (url) => InkWell(
                onTap: () async {
                  final uri = Uri.tryParse(url);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: DSTextWidget(
                  url,
                  color: context.colorPalette.brand.primary,
                  style: context.typography.bodySmall,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
            .toList(),
      ),
      AdDetailDateItem(:final dateTime) => SelectableText(
        dateTime?.toFormattedDate.toFullDateWithoutTime ?? '',
        style: context.typography.bodySmall.textStyle.copyWith(
          color: context.colorPalette.invertedBackground.onPrimary.color,
        ),
      ),
    };
  }
}

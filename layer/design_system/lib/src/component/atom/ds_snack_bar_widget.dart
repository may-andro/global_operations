import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum DSSnackBarType {
  success,
  error,
  info;

  DSColor getBackgroundColor(BuildContext context) {
    switch (this) {
      case DSSnackBarType.success:
        return context.colorPalette.semantic.success;
      case DSSnackBarType.error:
        return context.colorPalette.semantic.error;
      case DSSnackBarType.info:
        return context.colorPalette.semantic.info;
    }
  }

  DSColor getTextColor(BuildContext context) {
    switch (this) {
      case DSSnackBarType.success:
        return context.colorPalette.semantic.onSuccess;
      case DSSnackBarType.error:
        return context.colorPalette.semantic.onError;
      case DSSnackBarType.info:
        return context.colorPalette.semantic.onInfo;
    }
  }
}

class DSSnackBar {
  const DSSnackBar({
    required this.message,
    this.type = DSSnackBarType.info,
    this.duration = const Duration(seconds: 3),
  });

  final String message;
  final DSSnackBarType type;
  final Duration duration;

  SnackBar toSnackBar(BuildContext context) {
    return SnackBar(
      content: _ContentWidget(message: message, type: type),
      backgroundColor: type.getBackgroundColor(context).color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimen.radiusLevel1.value),
      ),
      duration: duration,
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({
    required this.message,
    this.type = DSSnackBarType.info,
  });

  final String message;
  final DSSnackBarType type;

  @override
  Widget build(BuildContext context) {
    return DSTextWidget(
      message,
      style: context.typography.bodyMedium,
      color: type.getTextColor(context),
    );
  }
}

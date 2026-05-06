import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/animated_form_widget.dart';

class AnimatedFormCardWidget extends StatelessWidget {
  const AnimatedFormCardWidget({
    super.key,
    required this.fields,
    required this.animationController,
    required this.onSubmit,
    this.submitButtonLabel = 'Submit',
    this.title,
    this.subTitle,
    this.isLoading = false,
    this.additionalActions = const [],
  });

  final List<FormFieldConfig> fields;
  final AnimationController animationController;
  final VoidCallback onSubmit;
  final String submitButtonLabel;
  final String? title;
  final String? subTitle;
  final bool isLoading;
  final List<Widget> additionalActions;

  @override
  Widget build(BuildContext context) {
    // Card animation (0.3s to 0.9s of total animation)
    final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.getFormCardWidth(constraints),
            maxHeight: constraints.maxHeight,
          ),
          child: AnimatedBuilder(
            animation: cardAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - cardAnimation.value)),
                child: Transform.scale(
                  scale: 0.9 + (0.1 * cardAnimation.value),
                  child: Opacity(
                    opacity: cardAnimation.value,
                    child: DsCardWidget(
                      backgroundColor: context.colorPalette.background.primary,
                      elevation: context.dimen.elevationLevel3,
                      radius: context.dimen.radiusLevel2,
                      child: Padding(
                        padding: EdgeInsets.all(context.space(factor: 3)),
                        child: AnimatedFormWidget(
                          fields: fields,
                          animationController: animationController,
                          onSubmit: onSubmit,
                          submitButtonLabel: submitButtonLabel,
                          title: title,
                          subTitle: subTitle,
                          isLoading: isLoading,
                          additionalActions: additionalActions,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

extension on BuildContext {
  double getFormCardWidth(BoxConstraints constraints) {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return 400;
      case DSDeviceWidthResolution.s:
        return 450;
      case DSDeviceWidthResolution.m:
        return max(450.0, constraints.maxWidth * 0.6);
      case DSDeviceWidthResolution.l:
        return max(500.0, constraints.maxWidth * 0.6);
      case DSDeviceWidthResolution.xl:
        return max(600.0, constraints.maxWidth * 0.6);
    }
  }
}

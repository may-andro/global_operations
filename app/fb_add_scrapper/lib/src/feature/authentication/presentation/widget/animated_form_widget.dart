import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class FormFieldConfig {
  const FormFieldConfig({required this.builder, this.key});

  final Widget Function(BuildContext context) builder;
  final Key? key;
}

class AnimatedFormWidget extends StatelessWidget {
  const AnimatedFormWidget({
    super.key,
    required this.fields,
    required this.animationController,
    required this.onSubmit,
    required this.submitButtonLabel,
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
    final formKey = GlobalKey<FormState>();

    // Create animations for each element
    final titleAnimation = title != null
        ? Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
            ),
          )
        : null;

    // SubTitle animation (after title)
    final subTitleAnimation = subTitle != null
        ? Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.1, 0.25, curve: Curves.easeOut),
            ),
          )
        : null;

    // Create field animations with staggered intervals
    final hasHeaderContent = title != null || subTitle != null;
    final fieldAnimations = fields.asMap().entries.map((entry) {
      final index = entry.key;
      final startInterval = hasHeaderContent
          ? 0.2 + (index * 0.1)
          : index * 0.15;
      final endInterval = hasHeaderContent
          ? 0.35 + (index * 0.1)
          : 0.15 + (index * 0.15);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(
            startInterval.clamp(0.0, 0.8),
            endInterval.clamp(0.2, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      );
    }).toList();

    // Submit button animation
    final submitButtonStartInterval = hasHeaderContent
        ? 0.4 + (fields.length * 0.1)
        : 0.15 + (fields.length * 0.15);
    final buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          submitButtonStartInterval.clamp(0.0, 0.8),
          (submitButtonStartInterval + 0.2).clamp(0.2, 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );

    // Additional actions animation
    final actionsAnimation = additionalActions.isNotEmpty
        ? Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval(
                (submitButtonStartInterval + 0.1).clamp(0.0, 0.9),
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          )
        : null;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DSVerticalSpacerWidget(3),

          // Animated title
          if (title != null && titleAnimation != null)
            AnimatedBuilder(
              animation: titleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -30 * (1 - titleAnimation.value)),
                  child: Opacity(
                    opacity: titleAnimation.value,
                    child: DSTextWidget(
                      title!,
                      color: context.colorPalette.neutral.grey9,
                      style: context.typography.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),

          // Animated subTitle
          if (subTitle != null && subTitleAnimation != null) ...[
            const DSVerticalSpacerWidget(1),
            AnimatedBuilder(
              animation: subTitleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -20 * (1 - subTitleAnimation.value)),
                  child: Opacity(
                    opacity: subTitleAnimation.value,
                    child: DSTextWidget(
                      subTitle!,
                      color: context.colorPalette.neutral.grey7,
                      style: context.typography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],

          if (title != null || subTitle != null)
            const DSVerticalSpacerWidget(3),

          // Animated form fields
          ...fields.asMap().entries.map((entry) {
            final index = entry.key;
            final field = entry.value;
            final animation = fieldAnimations[index];

            return Column(
              children: [
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - animation.value)),
                      child: Opacity(
                        opacity: animation.value,
                        child: Builder(
                          builder: (context) {
                            try {
                              return field.builder(context);
                            } catch (e) {
                              // Fallback widget if field builder fails
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (index < fields.length - 1) const DSVerticalSpacerWidget(2),
              ],
            );
          }),
          const DSVerticalSpacerWidget(3),

          // Animated submit button
          AnimatedBuilder(
            animation: buttonAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - buttonAnimation.value)),
                child: Transform.scale(
                  scale: 0.9 + (0.1 * buttonAnimation.value),
                  child: Opacity(
                    opacity: buttonAnimation.value,
                    child: DSButtonWidget(
                      label: submitButtonLabel,
                      onPressed: () => _handleSubmit(context, formKey),
                      isLoading: isLoading,
                      isDisabled: isLoading,
                    ),
                  ),
                ),
              );
            },
          ),

          // Animated additional actions
          if (additionalActions.isNotEmpty && actionsAnimation != null) ...[
            const DSVerticalSpacerWidget(2),
            AnimatedBuilder(
              animation: actionsAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: actionsAnimation.value,
                  child: Column(children: additionalActions),
                );
              },
            ),
          ],

          const DSVerticalSpacerWidget(3),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    onSubmit();
  }
}

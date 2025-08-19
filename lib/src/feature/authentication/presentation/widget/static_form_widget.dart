import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/widget/widget.dart';

sealed class FormFieldType {
  const FormFieldType({
    required this.textEditingController,
    required this.focusNode,
    this.isLoading = false,
    this.errorMessage,
  });

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final bool isLoading;
  final String? errorMessage;

  Widget build(BuildContext context);
}

class EmailFieldType extends FormFieldType {
  const EmailFieldType({
    required super.textEditingController,
    required super.focusNode,
    super.isLoading,
    super.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return EmailTextFieldWidget(
      textController: textEditingController,
      isEnabled: !isLoading,
      focusNode: focusNode,
      errorMessage: errorMessage,
    );
  }
}

class PasswordFieldType extends FormFieldType {
  const PasswordFieldType({
    required super.textEditingController,
    required super.focusNode,
    super.isLoading,
    super.errorMessage,
    this.labelText,
  });

  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return PasswordTextFieldWidget(
      textController: textEditingController,
      isEnabled: !isLoading,
      focusNode: focusNode,
      errorMessage: errorMessage,
      labelText: labelText,
    );
  }
}

class StaticFormWidget extends StatelessWidget {
  const StaticFormWidget({
    super.key,
    required this.formKey,
    required this.fields,
    required this.title,
    required this.submitButtonLabel,
    required this.onSubmit,
    this.isLoading = false,
    this.subTitle,
    this.additionalActions = const [],
  });

  final GlobalKey<FormState> formKey;
  final List<FormFieldType> fields;
  final String title;
  final String submitButtonLabel;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String? subTitle;
  final List<Widget> additionalActions;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DSVerticalSpacerWidget(3),
          DSTextWidget(
            title,
            style: context.typography.titleLarge,
            color: isLoading
                ? context.colorPalette.neutral.grey6
                : context.colorPalette.neutral.grey9,
            textAlign: TextAlign.center,
          ),
          if (subTitle != null) ...[
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              subTitle!,
              color: context.colorPalette.neutral.grey7,
              style: context.typography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const DSVerticalSpacerWidget(3),
          ...fields.asMap().entries.expand((entry) {
            final index = entry.key;
            final field = entry.value;
            return [
              field.build(context),
              if (index < fields.length - 1) const DSVerticalSpacerWidget(1),
            ];
          }),
          const DSVerticalSpacerWidget(3),
          DSButtonWidget(
            label: submitButtonLabel,
            onPressed: () {
              if (formKey.currentState?.validate() != true) {
                return;
              }
              onSubmit();
            },
            isLoading: isLoading,
            isDisabled: isLoading,
          ),
          const DSVerticalSpacerWidget(3),
          if (additionalActions.isNotEmpty) ...[
            const DSVerticalSpacerWidget(2),
            Column(children: additionalActions),
          ],
          const DSVerticalSpacerWidget(3),
        ],
      ),
    );
  }
}

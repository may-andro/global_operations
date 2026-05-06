import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

class PasswordTextFieldWidget extends StatelessWidget {
  const PasswordTextFieldWidget({
    required this.textController,
    this.isEnabled = true,
    this.onFieldSubmitted,
    this.errorMessage,
    this.labelText,
    this.focusNode,
    super.key,
  });

  final TextEditingController textController;
  final bool isEnabled;
  final void Function(String)? onFieldSubmitted;
  final String? errorMessage;
  final String? labelText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return DSTextFieldWidget(
      key: Key('${labelText ?? ''}password_input_widget'),
      controller: textController,
      hintText: 'xxxxxx',
      labelText: labelText ?? context.localizations.password,
      enabled: isEnabled,
      textFieldType: TextFieldType.password,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: onFieldSubmitted,
      validator: (input) {
        if (input == null || input.isEmpty) {
          return TextFieldValidationData.error(
            context.localizations.errorEmptyPassword,
          );
        }
        if (input.length < 6) {
          return TextFieldValidationData.error(
            context.localizations.errorPasswordTooSmall,
          );
        }
        if (input.length > 12) {
          return TextFieldValidationData.error(
            context.localizations.errorPasswordTooLarge,
          );
        }

        if (errorMessage case final String errorMessage) {
          return TextFieldValidationData.error(errorMessage);
        }
        return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: const [AutofillHints.password],
    );
  }
}

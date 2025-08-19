import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
      labelText: labelText ?? 'Password',
      enabled: isEnabled,
      textFieldType: TextFieldType.password,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: onFieldSubmitted,
      validator: (input) {
        if (input == null || input.isEmpty) {
          return const TextFieldValidationData.error(
            'Password  can not be empty',
          );
        }
        if (input.length < 6) {
          return const TextFieldValidationData.error(
            'Password must be at least 6 characters',
          );
        }
        if (input.length > 12) {
          return const TextFieldValidationData.error(
            'Password must be at most 12 characters',
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

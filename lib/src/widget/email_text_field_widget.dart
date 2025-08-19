import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget({
    required this.textController,
    this.isEnabled = true,
    this.errorMessage,
    this.focusNode,
    super.key,
  });

  final TextEditingController textController;
  final bool isEnabled;
  final FocusNode? focusNode;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return DSTextFieldWidget(
      key: const Key('email_input_widget'),
      controller: textController,
      hintText: 'bob@global.com',
      labelText: 'Email',
      enabled: isEnabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (input) {
        if (input == null || input.isEmpty) {
          return const TextFieldValidationData.error('Email can not be empty');
        }
        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input)) {
          return const TextFieldValidationData.error(
            'Please enter a valid email',
          );
        }

        if (errorMessage case final String errorMessage) {
          return TextFieldValidationData.error(errorMessage);
        }
        return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: const [AutofillHints.email],
    );
  }
}

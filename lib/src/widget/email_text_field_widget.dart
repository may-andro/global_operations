import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

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
      labelText: context.localizations.email,
      enabled: isEnabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (input) {
        if (input == null || input.isEmpty) {
          return TextFieldValidationData.error(
            context.localizations.errorEmptyEmail,
          );
        }
        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input)) {
          return TextFieldValidationData.error(
            context.localizations.errorInvalidEmail,
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

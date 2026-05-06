import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/reset_password/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/widget.dart';
import 'package:global_ops/src/route/route.dart';

class FormCardWidget extends StatelessWidget {
  const FormCardWidget({
    super.key,
    required this.formKey,
    required this.textController,
    required this.focusNode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return StaticFormCardWidget(
      child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          switch (state) {
            case final ResetPasswordSuccessState _:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: context.localizations.resetPasswordSuccessMessage,
                  type: DSSnackBarType.success,
                ),
              );
              context.pop();
            case final ResetPasswordErrorState state:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: state.message,
                  type: DSSnackBarType.error,
                ),
              );
            default:
              break;
          }
        },
        child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoadingState;

            return StaticFormWidget(
              formKey: formKey,
              title: context.localizations.resetPasswordTitle,
              subTitle: context.localizations.resetPasswordSubtitle,
              fields: [
                EmailFieldType(
                  isLoading: isLoading,
                  textEditingController: textController,
                  focusNode: focusNode,
                ),
              ],
              submitButtonLabel: context.localizations.submit,
              onSubmit: () => _handleResetPassword(context),
              isLoading: isLoading,
            );
          },
        ),
      ),
    );
  }

  void _handleResetPassword(BuildContext context) {
    context.read<ResetPasswordBloc>().add(
      ResetPasswordRequestedEvent(textController.text.trim()),
    );
  }
}

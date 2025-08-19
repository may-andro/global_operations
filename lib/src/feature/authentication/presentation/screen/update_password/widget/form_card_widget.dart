import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/extension/failure_extension.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/widget.dart';

class FormCardWidget extends StatelessWidget {
  const FormCardWidget({
    super.key,
    required this.formKey,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.currentPasswordFocusNode,
    required this.newPasswordFocusNode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final FocusNode currentPasswordFocusNode;
  final FocusNode newPasswordFocusNode;

  @override
  Widget build(BuildContext context) {
    return StaticFormCardWidget(
      child: BlocListener<UpdatePasswordBloc, UpdatePasswordState>(
        listener: (context, state) {
          switch (state) {
            case final UpdatePasswordSuccessState _:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: context.localizations.updatePasswordSuccess,
                  type: DSSnackBarType.success,
                ),
              );
              Navigator.pop(context, true);
            case final UpdatePasswordGetProfileErrorState errorState:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: errorState.failure.getLocalizedMessage(context),
                  type: DSSnackBarType.error,
                ),
              );
            case final UpdatePasswordErrorState errorState:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: errorState.failure.getLocalizedMessage(context),
                  type: DSSnackBarType.error,
                ),
              );
            default:
              break;
          }
        },
        child: BlocBuilder<UpdatePasswordBloc, UpdatePasswordState>(
          builder: (context, state) {
            final isLoading = state is UpdatePasswordLoadingState;

            return StaticFormWidget(
              formKey: formKey,
              title: context.localizations.updatePasswordTitle,
              subTitle: context.localizations.updatePasswordSubtitle,
              fields: [
                PasswordFieldType(
                  isLoading: isLoading,
                  focusNode: currentPasswordFocusNode,
                  textEditingController: currentPasswordController,
                  labelText: context.localizations.currentPassword,
                ),
                PasswordFieldType(
                  isLoading: isLoading,
                  focusNode: newPasswordFocusNode,
                  textEditingController: newPasswordController,
                  labelText: context.localizations.newPassword,
                ),
              ],
              submitButtonLabel: context.localizations.submit,
              onSubmit: () => _handleUpdatePassword(context),
              isLoading: isLoading,
            );
          },
        ),
      ),
    );
  }

  void _handleUpdatePassword(BuildContext context) {
    final bloc = context.read<UpdatePasswordBloc>();
    final userProfile = bloc.state.userProfile;
    if (userProfile case final UserProfileEntity userProfile) {
      bloc.add(
        UpdatePasswordRequestedEvent(
          email: userProfile.email,
          currentPassword: currentPasswordController.text.trim(),
          newPassword: newPasswordController.text.trim(),
        ),
      );
    }
  }
}

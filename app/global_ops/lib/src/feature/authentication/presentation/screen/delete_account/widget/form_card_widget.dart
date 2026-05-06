import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/extension/failure_extension.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/delete_account/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/widget.dart';

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
      child: BlocListener<DeleteAccountBloc, DeleteAccountState>(
        listener: (context, state) {
          switch (state) {
            case final DeleteAccountSuccessState _:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: context.localizations.deleteAccountSuccess,
                  type: DSSnackBarType.success,
                ),
              );
              Navigator.pop(context, true);
            case final DeleteAccountGetProfileErrorState errorState:
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: errorState.failure.getLocalizedMessage(context),
                  type: DSSnackBarType.error,
                ),
              );
            case final DeleteAccountSubmissionErrorState errorState:
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
        child: BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
          builder: (context, state) {
            final isLoading = state is DeleteAccountLoadingState;

            return StaticFormWidget(
              formKey: formKey,
              title: context.localizations.deleteAccountTitle,
              subTitle: context.localizations.deleteAccountSubtitle,
              fields: [
                PasswordFieldType(
                  isLoading: isLoading,
                  textEditingController: textController,
                  focusNode: focusNode,
                ),
              ],
              submitButtonLabel: context.localizations.submit,
              onSubmit: () => _handleDeleteAccount(context),
              isLoading: isLoading,
            );
          },
        ),
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context) {
    final bloc = context.read<DeleteAccountBloc>();
    final userProfile = bloc.state.userProfile;
    if (userProfile case final UserProfileEntity userProfile) {
      bloc.add(
        DeleteAccountSubmittedEvent(
          email: userProfile.email,
          password: textController.text.trim(),
        ),
      );
    }
  }
}

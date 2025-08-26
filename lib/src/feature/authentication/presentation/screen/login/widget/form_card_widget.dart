import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/reset_password/reset_password_screen.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/widget.dart';
import 'package:global_ops/src/feature/home/home.dart';
import 'package:global_ops/src/route/route.dart';

class FormCardWidget extends StatelessWidget {
  const FormCardWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return StaticFormCardWidget(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state) {
            case LoginSuccessState():
              context.pushNamed(HomeModuleRoute.home.name);
            case LoginFailureState(:final message):
              context.showSnackBar(
                snackBar: DSSnackBar(
                  message: message,
                  type: DSSnackBarType.error,
                ),
              );
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoadingState;

          return StaticFormWidget(
            formKey: formKey,
            title: 'Start Session',
            fields: [
              EmailFieldType(
                isLoading: isLoading,
                focusNode: emailFocusNode,
                textEditingController: emailController,
              ),
              PasswordFieldType(
                isLoading: isLoading,
                focusNode: passwordFocusNode,
                textEditingController: passwordController,
              ),
            ],
            additionalAction: Align(
              alignment: Alignment.topRight,
              child: FittedBox(
                child: DSButtonWidget(
                  onPressed: () => ResetPasswordScreen.navigate(context),
                  label: 'Forgot Password?',
                  variant: DSButtonVariant.text,
                ),
              ),
            ),
            submitButtonLabel: 'Login',
            onSubmit: () => _handleLogin(context),
            isLoading: isLoading,
          );
        },
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    context.read<LoginBloc>().add(
      LoginSubmittedEvent(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
  }
}

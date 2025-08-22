import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/route/route.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/widget/widget.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/route/route.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  static void navigate(BuildContext context) {
    context.push(AuthenticationModuleRoute.updatePassword.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorPalette.brand.prominent.color,
      appBar: DSAppBarWidget(
        height: DSAppBarWidget.getHeight(context),
        backgroundColor: context.colorPalette.brand.prominent,
        iconColor: context.colorPalette.neutral.white,
      ),
      body: BlocProvider(
        create: (_) =>
            appServiceLocator.get<UpdatePasswordBloc>()
              ..add(const LoadUpdatePasswordAccountEvent()),
        child: const ContentWidget(),
      ),
    );
  }
}

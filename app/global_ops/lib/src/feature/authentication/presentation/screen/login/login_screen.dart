import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/widget/widget.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appServiceLocator.get<LoginBloc>(),
      child: Scaffold(
        backgroundColor: context.colorPalette.brand.prominent.color,
        body: const ContentWidget(),
      ),
    );
  }
}

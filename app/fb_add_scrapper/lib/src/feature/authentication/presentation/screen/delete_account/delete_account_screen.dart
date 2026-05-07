import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:fb_add_scrapper/src/feature/authentication/presentation/route/route.dart';
import 'package:fb_add_scrapper/src/feature/authentication/presentation/screen/delete_account/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/authentication/presentation/screen/delete_account/widget/widget.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:fb_add_scrapper/src/route/route.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  static void navigate(BuildContext context) {
    context.push(AuthenticationModuleRoute.deleteAccount.path);
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
            appServiceLocator.get<DeleteAccountBloc>()
              ..add(const LoadDeleteAccountEvent()),
        child: const ContentWidget(),
      ),
    );
  }
}

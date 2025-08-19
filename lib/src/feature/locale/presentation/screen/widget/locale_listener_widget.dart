import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class LocaleListenerWidget extends StatelessWidget {
  const LocaleListenerWidget({
    super.key,
    required this.appLocale,
    required this.builder,
  });

  final AppLocale appLocale;
  final Widget Function(BuildContext context, AppLocale appLocale) builder;

  @override
  Widget build(BuildContext context) {
    final localeStream = appServiceLocator.get<GetLocaleStreamUseCase>().call();

    return StreamBuilder<AppLocale>(
      stream: localeStream,
      initialData: appLocale,
      builder: (context, asyncSnapshot) {
        return builder(context, asyncSnapshot.data ?? appLocale);
      },
    );
  }
}

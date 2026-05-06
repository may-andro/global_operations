import 'package:global_ops/src/route/route.dart';

class LocaleModuleRoute extends ModuleRoute {
  const LocaleModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const LocaleModuleRoute localeSelection = LocaleModuleRoute._(
    'localeSelection',
    '/locale_selection',
  );
}

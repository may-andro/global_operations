import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/locale/data/cache/app_locale_cache.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  LocaleRepositoryImpl(this._appLocale, this._appLocaleCache);

  final AppLocaleCache _appLocaleCache;
  final AppLocale _appLocale;

  final _localeSteamController = StreamController<AppLocale>.broadcast();

  @override
  Stream<AppLocale> get appLocaleStream =>
      _localeSteamController.stream.distinct();

  @override
  Future<AppLocale> get appLocale async {
    final cachedLocale = await _appLocaleCache.get();
    if (cachedLocale != null) {
      return cachedLocale;
    }
    return _appLocale;
  }

  @override
  Future<void> updateAppLocale(AppLocale appLocale) async {
    await _appLocaleCache.put(appLocale);

    await appServiceLocator.unregister<AppLocale>();
    appServiceLocator.registerSingleton<AppLocale>(() => appLocale);

    Intl.defaultLocale = appLocale.languageCode;

    _localeSteamController.add(appLocale);
  }
}

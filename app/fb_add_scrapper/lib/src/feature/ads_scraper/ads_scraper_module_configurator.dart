import 'package:fb_add_scrapper/src/feature/ads_scraper/data/repository/repository.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/service/service.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/bloc/bloc.dart';
import 'package:firebase/firebase.dart';
import 'package:module_injector/module_injector.dart';

class AdsScraperModuleConfigurator implements ModuleConfigurator {
  AdsScraperModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    // Data
    serviceLocator.registerSingleton<FbAdsApiService>(() => FbAdsApiService());

    serviceLocator.registerSingleton<FbAdsRepository>(
      () => FbAdsRepositoryImpl(
        apiService: serviceLocator.get<FbAdsApiService>(),
        firestoreController: serviceLocator.get<FbFirestoreController>(),
      ),
    );

    // Domain
    serviceLocator.registerFactory<SearchFbAdsUseCase>(
      () => SearchFbAdsUseCase(serviceLocator.get<FbAdsRepository>()),
    );

    serviceLocator.registerFactory<GetSavedAdsUseCase>(
      () => GetSavedAdsUseCase(serviceLocator.get<FbAdsRepository>()),
    );

    // Presentation – access token is read from Remote Config.
    // Set `fb_ads_access_token` in Firebase Remote Config console, or call
    // [updateAccessToken] at runtime after the user enters their token.
    serviceLocator.registerFactory<AdsScrapeBloc>(
      () {
        final remoteConfig = serviceLocator.get<FbRemoteConfigController>();
        final accessToken = remoteConfig
            .getValueForKey('fb_ads_access_token')
            .asString();
        return AdsScrapeBloc(
          searchUseCase: serviceLocator.get<SearchFbAdsUseCase>(),
          getSavedAdsUseCase: serviceLocator.get<GetSavedAdsUseCase>(),
          repository: serviceLocator.get<FbAdsRepository>(),
          accessToken: accessToken,
        );
      },
    );
  }
}


import 'package:fb_add_scrapper/src/feature/ads_scraper/data/data_source/fb_ads_cloud_function_data_source.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/data_source/fb_ads_firestore_data_source.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/mapper/mapper.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/repository/repository.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/domain.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/route/ads_scraper_module_route_configurator.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/route/route.dart';
import 'package:firebase/firebase.dart';
import 'package:module_injector/module_injector.dart';

class AdsScraperModuleConfigurator implements ModuleConfigurator {
  AdsScraperModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {
    serviceLocator.get<ModuleRouteController>().register(
      AdsScraperModuleRouteConfigurator(),
    );
  }

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    _registerDataLayerDependencies(serviceLocator);
    _registerDomainLayerDependencies(serviceLocator);
    _registerPresentationLayerDependencies(serviceLocator);
  }

  void _registerDataLayerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<FbAdMapper>(() => const FbAdMapper());
    serviceLocator.registerFactory<FbPageInfoMapper>(
      () => const FbPageInfoMapper(),
    );
    serviceLocator.registerFactory<SearchTermMapper>(
      () => const SearchTermMapper(),
    );

    serviceLocator.registerSingleton<FbAdsCloudFunctionDataSource>(
      () => FbAdsCloudFunctionDataSource(
        functionController: serviceLocator.get<FbFunctionController>(),
      ),
    );

    serviceLocator.registerSingleton<FbAdsFirestoreDataSource>(
      () => FbAdsFirestoreDataSource(
        firestoreController: serviceLocator.get<FbFirestoreController>(),
      ),
    );

    serviceLocator.registerSingleton<FbAdsRepository>(
      () => FbAdsRepositoryImpl(
        cloudFunctionDataSource: serviceLocator
            .get<FbAdsCloudFunctionDataSource>(),
        firestoreController: serviceLocator.get<FbFirestoreController>(),
        firestoreDataSource: serviceLocator.get<FbAdsFirestoreDataSource>(),
        fbAdMapper: serviceLocator.get<FbAdMapper>(),
        fbPageInfoMapper: serviceLocator.get<FbPageInfoMapper>(),
        searchTermMapper: serviceLocator.get<SearchTermMapper>(),
      ),
    );
  }

  void _registerDomainLayerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<GetPageInfoUseCase>(
      () => GetPageInfoUseCase(serviceLocator.get<FbAdsRepository>()),
    );
    serviceLocator.registerFactory<TriggerScrapeUseCase>(
      () => TriggerScrapeUseCase(serviceLocator.get<FbAdsRepository>()),
    );
    serviceLocator.registerFactory<WatchSearchTermsUseCase>(
      () => WatchSearchTermsUseCase(serviceLocator.get<FbAdsRepository>()),
    );
    serviceLocator.registerFactory<GetAdsForTermUseCase>(
      () => GetAdsForTermUseCase(serviceLocator.get<FbAdsRepository>()),
    );
  }

  void _registerPresentationLayerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<AdDetailBloc>(
      () => AdDetailBloc(
        getPageInfoUseCase: serviceLocator.get<GetPageInfoUseCase>(),
      ),
    );
    serviceLocator.registerFactory<AdsSearchBloc>(
      () => AdsSearchBloc(
        triggerScrapeUseCase: serviceLocator.get<TriggerScrapeUseCase>(),
        watchSearchTermsUseCase: serviceLocator.get<WatchSearchTermsUseCase>(),
      ),
    );
    serviceLocator.registerFactory<AdsListBloc>(
      () => AdsListBloc(
        getAdsForTermUseCase: serviceLocator.get<GetAdsForTermUseCase>(),
      ),
    );
  }
}

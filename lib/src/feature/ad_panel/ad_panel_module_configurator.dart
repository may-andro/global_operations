import 'package:global_ops/src/feature/ad_panel/data/data.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/presentation.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:module_injector/module_injector.dart';

class AdPanelModuleConfigurator implements ModuleConfigurator {
  AdPanelModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {
    serviceLocator.get<ModuleRouteController>().register(
      AdPanelModuleRouteConfigurator(),
    );
  }

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<GeoMapper>(() => GeoMapper());
    serviceLocator.registerFactory<AdPanelMapper>(
      () => AdPanelMapper(serviceLocator.get()),
    );

    serviceLocator.registerFactory<AdPanelRepository>(
      () => AdPanelRepositoryImpl(serviceLocator.get(), serviceLocator.get()),
    );

    serviceLocator.registerFactory<CompressImageFileUseCase>(
      () => CompressImageFileUseCase(),
    );
    serviceLocator.registerFactory<CompressRawImageUseCase>(
      () => CompressRawImageUseCase(),
    );
    serviceLocator.registerFactory<GetAdPanelsUseCase>(
      () => GetAdPanelsUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<GetAdPanelsWithinDistanceUseCase>(
      () => GetAdPanelsWithinDistanceUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<GetAdPanelsWithinDistanceStreamUseCase>(
      () => GetAdPanelsWithinDistanceStreamUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<UpdateAdPanelsUseCase>(
      () => UpdateAdPanelsUseCase(serviceLocator.get(), serviceLocator.get()),
    );
    serviceLocator.registerFactory<UploadImageFileUseCase>(
      () => UploadImageFileUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<UploadRawImageUseCase>(
      () => UploadRawImageUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<DeleteAdPanelImageUseCase>(
      () => DeleteAdPanelImageUseCase(serviceLocator.get()),
    );

    serviceLocator.registerFactory<AdPanelsBloc>(
      () => AdPanelsBloc(serviceLocator.get()),
    );
    serviceLocator.registerFactory<PaginatedAdPanelsBloc>(
      () => PaginatedAdPanelsBloc(serviceLocator.get()),
    );
    serviceLocator.registerFactory<ProximityAdPanelsBloc>(
      () => ProximityAdPanelsBloc(serviceLocator.get(), serviceLocator.get()),
    );
    serviceLocator.registerFactory<AdPanelBloc>(
      () => AdPanelBloc(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ),
    );
  }
}

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/route/ads_scraper_module_route.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/widget.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Shows all details for a single Facebook Ad.
class AdDetailScreen extends StatelessWidget {
  const AdDetailScreen({super.key, required this.ad});

  final FbAdEntity ad;

  static void navigate(BuildContext context, {required FbAdEntity ad}) {
    context.pushNamed(AdsScraperModuleRoute.adDetail.name, extra: ad);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = appServiceLocator.get<AdDetailBloc>();
        if (ad.pageId != null) bloc.add(LoadPageInfoEvent(ad.pageId!));
        return bloc;
      },
      child: AdDetailViewWidget(ad: ad),
    );
  }
}

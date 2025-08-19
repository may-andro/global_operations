import 'dart:ui';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/extension/extension.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/ad_panel_detail_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/loading_content_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/multiple_panels_found_widget.dart';
import 'package:global_ops/src/feature/location/location.dart';

class MapContentWidget extends StatefulWidget {
  const MapContentWidget({
    required this.location,
    required this.adPanelsMap,
    required this.isLoading,
    this.circleRadius = 0.0,
    super.key,
  });

  final LocationEntity location;
  final Map<String, List<AdPanelEntity>> adPanelsMap;
  final bool isLoading;
  final double circleRadius;

  @override
  State<MapContentWidget> createState() => _MapContentWidgetState();
}

class _MapContentWidgetState extends State<MapContentWidget> {
  late final DSMapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = DSMapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adPanelsMap = widget.adPanelsMap;
    final List<DSMapItem> mapItems = adPanelsMap.values
        .map((e) => e.first)
        .dsMapItems;

    // Ensure markers update when state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.updateMarkers(mapItems);
    });

    return Stack(
      children: [
        DSMapWidget(
          controller: _mapController,
          center: LatLng(widget.location.latitude, widget.location.longitude),
          items: mapItems,
          onMarkerTap: (_, mapItems) {
            final adPanels = mapItems.toAdPanels(adPanelsMap);
            AdPanelDetailWidget.showAsDialogOrBottomSheet(
              context,
              adPanels: adPanels,
            );
          },
          onMultipleMarkersOnSameSpotClusterTap: (_, mapItems) {
            final clusteredMap = mapItems.getAdPanelsMap(adPanelsMap);
            if (clusteredMap.isEmpty) return;
            MultiplePanelsFoundWidget.showAsDialogOrBottomSheet(
              context,
              adPanelsMap: clusteredMap,
            );
          },
          circleRadius: widget.circleRadius,
        ),
        AnimatedSwitcher(
          duration: 300.ms,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: widget.isLoading
              ? ClipRect(
                  child: BackdropFilter(
                    key: const ValueKey('loading'),
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: ColoredBox(
                      color: context
                          .colorPalette
                          .invertedBackground
                          .primary
                          .color
                          .withAlpha(20),
                      child: const LoadingContentWidget(),
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('not_loading')),
        ),
      ],
    );
  }
}

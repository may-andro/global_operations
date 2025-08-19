import 'package:design_system/design_system.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

extension DSMapItemsExtension on List<DSMapItem> {
  List<AdPanelEntity> toAdPanels(Map<String, List<AdPanelEntity>> adPanelsMap) {
    return map(
      (mapItem) => adPanelsMap[mapItem.id],
    ).whereType<List<AdPanelEntity>>().expand((e) => e).toList();
  }

  Map<String, List<AdPanelEntity>> getAdPanelsMap(
    Map<String, List<AdPanelEntity>> adPanelsMap,
  ) {
    final ids = {for (final item in this) item.id};
    return adPanelsMap.entries.where((entry) => ids.contains(entry.key)).fold(
      <String, List<AdPanelEntity>>{},
      (map, entry) {
        map[entry.key] = entry.value;
        return map;
      },
    );
  }
}

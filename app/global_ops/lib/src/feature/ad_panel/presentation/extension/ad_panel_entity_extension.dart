import 'package:design_system/design_system.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

extension AdPanelsToDSMapItems on Iterable<AdPanelEntity> {
  List<DSMapItem> get dsMapItems {
    return map(
      (adPanel) => DSMapItem(
        id: adPanel.objectNumber,
        latitude: adPanel.latitude,
        longitude: adPanel.longitude,
        isSelected: adPanel.hasBeenEdited,
      ),
    ).toList();
  }
}

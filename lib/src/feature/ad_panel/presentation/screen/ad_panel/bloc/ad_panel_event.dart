import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

abstract class AdPanelEvent extends Equatable {
  const AdPanelEvent();
}

class LoadAdPanelsEvent extends AdPanelEvent {
  const LoadAdPanelsEvent(this.adPanels);

  final List<AdPanelEntity> adPanels;

  @override
  List<Object?> get props => [adPanels];
}

class EditAdPanelEvent extends AdPanelEvent {
  const EditAdPanelEvent(this.index, this.updatedPanel);

  final int index;
  final AdPanelEntity updatedPanel;

  @override
  List<Object?> get props => [index, updatedPanel];
}

class DeleteImageEvent extends AdPanelEvent {
  const DeleteImageEvent(this.fileUrl);

  final String fileUrl;

  @override
  List<Object?> get props => [fileUrl];
}

class UpdateAdPanelsEvent extends AdPanelEvent {
  const UpdateAdPanelsEvent();

  @override
  List<Object?> get props => [];
}

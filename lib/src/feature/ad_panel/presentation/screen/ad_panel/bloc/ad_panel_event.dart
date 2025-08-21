import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';

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

class PickImageFileOnMobileEvent extends AdPanelEvent {
  const PickImageFileOnMobileEvent({
    required this.adPanel,
    required this.index,
    required this.imagePickerSource,
  });

  final AdPanelEntity adPanel;
  final int index;
  final ImagePickerSource imagePickerSource;

  @override
  List<Object?> get props => [adPanel, index, imagePickerSource];
}

class PickImageFileOnWebEvent extends AdPanelEvent {
  const PickImageFileOnWebEvent({required this.adPanel, required this.index});

  final AdPanelEntity adPanel;
  final int index;

  @override
  List<Object?> get props => [adPanel, index];
}

class DeleteImageEvent extends AdPanelEvent {
  const DeleteImageEvent({
    required this.index,
    required this.adPanel,
    this.url,
    this.file,
    this.rawFile,
  });

  final int index;
  final AdPanelEntity adPanel;
  final String? url;
  final File? file;
  final Uint8List? rawFile;

  @override
  List<Object?> get props => [index, adPanel, url, file, rawFile];
}

class UpdateAdPanelsEvent extends AdPanelEvent {
  const UpdateAdPanelsEvent();

  @override
  List<Object?> get props => [];
}

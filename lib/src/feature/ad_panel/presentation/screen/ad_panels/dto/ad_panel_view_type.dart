import 'package:flutter/material.dart';

enum AdPanelViewType {
  list(Icons.map, 1),
  map(Icons.list, 0);

  const AdPanelViewType(this.icon, this.positionIndex);

  final IconData icon;

  final int positionIndex;

  bool get isMapType => this == AdPanelViewType.map;

  bool get isListType => this == AdPanelViewType.list;
}

import 'package:flutter/material.dart';

enum AdPanelViewType {
  list(Icons.map),
  map(Icons.list);

  const AdPanelViewType(this.icon);

  final IconData icon;

  bool get isMapType => this == AdPanelViewType.map;

  bool get isListType => this == AdPanelViewType.list;
}

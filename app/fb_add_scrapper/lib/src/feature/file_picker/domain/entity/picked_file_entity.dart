import 'package:flutter/foundation.dart';

class PickedFileEntity {
  PickedFileEntity({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

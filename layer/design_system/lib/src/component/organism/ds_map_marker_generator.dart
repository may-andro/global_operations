import 'dart:ui';

import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DsMapMarkerGenerator {
  DsMapMarkerGenerator._();

  static final Map<String, BitmapDescriptor> _iconCache = {};

  static double get _markerSize => 36.0 * _markerSizeModifier;

  static double get _strokeWidth => 2.0 * _markerSizeModifier;

  static double get _iconSize => _markerSize * 0.5;

  static double _markerSizeModifier = 1;

  /// Gets the optimal marker size modifier based on the current platform
  static double get _optimalMarkerSizeModifier {
    if (kIsWeb) {
      // Web browsers typically need smaller markers due to different DPI handling
      return 1;
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      // Mobile devices can handle larger markers and need them for touch interaction
      return 2.5;
    } else {
      // Desktop platforms (macOS, Windows, Linux)
      return 2.0;
    }
  }

  static Future<BitmapDescriptor?> createBitmap(
    String markerId,
    bool isSelected,
    int clusterCount,
    DSTheme theme,
  ) async {
    final isClustered = clusterCount > 1;

    final cachedIcon = _getCachedIcon('${markerId}_$clusterCount', isSelected);
    if (cachedIcon != null) {
      return cachedIcon;
    }

    _markerSizeModifier = _optimalMarkerSizeModifier;

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintCircle(canvas, theme, isSelected, isClustered);
    _paintStroke(canvas, theme, isSelected, isClustered);
    if (isClustered) {
      _paintClusterText(theme, canvas, clusterCount.toString());
    } else {
      _paintIcon(canvas, theme, isSelected);
    }

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
      _markerSize.round(),
      _markerSize.round(),
    );
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    if (bytes == null) {
      return null;
    }
    final icon = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    _setCachedIcon('${markerId}_$clusterCount', isSelected, icon);
    return icon;
  }

  static String _iconKey(String id, bool isSelected) => '$id-$isSelected';

  static BitmapDescriptor? _getCachedIcon(String id, bool isSelected) {
    final key = _iconKey(id, isSelected);
    return _iconCache[key];
  }

  static void _setCachedIcon(
    String id,
    bool isSelected,
    BitmapDescriptor icon,
  ) {
    final key = _iconKey(id, isSelected);
    _iconCache[key] = icon;
  }

  static void _paintCircle(
    Canvas canvas,
    DSTheme theme,
    bool isSelected,
    bool isClustered,
  ) {
    final color = isClustered
        ? theme.colorPalette.brand.primary.color
        : isSelected
        ? theme.colorPalette.semantic.info.color
        : theme.colorPalette.brand.secondary.color;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(
      Offset(_markerSize * 0.5, _markerSize * 0.5),
      _markerSize * 0.5,
      paint,
    );
  }

  static void _paintStroke(
    Canvas canvas,
    DSTheme theme,
    bool isSelected,
    bool isClustered,
  ) {
    final color = isClustered
        ? theme.colorPalette.brand.primary.color
        : isSelected
        ? theme.colorPalette.semantic.infoContainer.color
        : theme.colorPalette.brand.secondary.color;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(
      Offset(_markerSize * 0.5, _markerSize * 0.5),
      (_markerSize * 0.5) - (_strokeWidth * 0.5),
      paint,
    );
  }

  static void _paintIcon(Canvas canvas, DSTheme theme, bool isSelected) {
    const icon = Icons.ad_units_rounded;
    final color = isSelected
        ? theme.colorPalette.semantic.infoContainer.color
        : theme.colorPalette.neutral.white.color;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final centreOffset = _markerSize * 0.5;
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: _iconSize,
        fontFamily: icon.fontFamily,
        color: color,
        letterSpacing: 0.0,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centreOffset - textPainter.width / 2,
        centreOffset - textPainter.height / 2,
      ),
    );
  }

  static void _paintClusterText(DSTheme theme, Canvas canvas, String count) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final fontSize = _markerSize * 0.4;
    final centreOffset = _markerSize * 0.5;
    textPainter.text = TextSpan(
      text: count,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: theme.colorPalette.neutral.white.color,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centreOffset - textPainter.width / 2,
        centreOffset - textPainter.height / 2,
      ),
    );
  }
}

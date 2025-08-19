import 'package:flutter/material.dart';

class DSDraggableScrollableSheetWidget extends StatefulWidget {
  const DSDraggableScrollableSheetWidget({
    super.key,
    required this.contentBuilder,
    this.maxInitialHeight = 0.75,
    this.snap = false,
    this.minChildSize,
  });

  final ScrollableWidgetBuilder contentBuilder;
  final double maxInitialHeight;
  final bool snap;
  final double? minChildSize;

  @override
  State<DSDraggableScrollableSheetWidget> createState() =>
      _DSDraggableScrollableSheetWidgetState();
}

class _DSDraggableScrollableSheetWidgetState
    extends State<DSDraggableScrollableSheetWidget> {
  final GlobalKey _key = GlobalKey();

  double? _height;

  static const double _maxHeight = 0.9;
  static const double _defaultMinHeight = 0.25;

  @override
  void initState() {
    super.initState();
    _getContentHeightAndRebuild();
  }

  @override
  void didUpdateWidget(covariant DSDraggableScrollableSheetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getContentHeightAndRebuild();
  }

  void _getContentHeightAndRebuild() {
    // ignore: ban-name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        final contentHeight = _key.currentContext?.size?.height;
        if (contentHeight != null) {
          _height = contentHeight;
        }
      });
    });
  }

  double _getMaxChildSize(double screenHeight) {
    final maxHeight = _maxHeight * screenHeight;
    final minHeight = _minChildSize * screenHeight;
    final calculatedHeight = _height ?? maxHeight;
    if (calculatedHeight > maxHeight) {
      return maxHeight / screenHeight;
    }
    if (calculatedHeight < minHeight) {
      return minHeight / screenHeight;
    }
    return calculatedHeight / screenHeight;
  }

  double _getInitialChildSize(double screenHeight) {
    final maxInitialHeight = widget.maxInitialHeight * screenHeight;
    final minInitialHeight = _minChildSize * screenHeight;
    final calculatedHeight = _height ?? maxInitialHeight;
    if (calculatedHeight > maxInitialHeight) {
      return maxInitialHeight / screenHeight;
    }
    if (calculatedHeight < minInitialHeight) {
      return minInitialHeight / screenHeight;
    }
    return calculatedHeight / screenHeight;
  }

  double get _minChildSize {
    final minHeight = widget.minChildSize;

    if (minHeight == null || minHeight < _defaultMinHeight) {
      return _defaultMinHeight;
    } else {
      return minHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return DraggableScrollableSheet(
      expand: false,
      snap: widget.snap,
      maxChildSize: _getMaxChildSize(screenHeight),
      minChildSize: _minChildSize,
      initialChildSize: _getInitialChildSize(screenHeight),
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  key: _key,
                  child: widget.contentBuilder(context, scrollController),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

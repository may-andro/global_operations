import 'package:flutter/material.dart';

Future<T?> showDSModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useSafeArea = false,
  bool? showDragHandle,
}) {
  return showDSModalBottomSheet<T>(
    context: context,
    builder: (context) => SafeArea(child: builder(context)),
    backgroundColor: backgroundColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
  );
}

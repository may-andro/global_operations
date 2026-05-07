import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class LoadingContentWidget extends StatelessWidget {
  const LoadingContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: DSLoadingWidget(size: context.space(factor: 5)));
  }
}

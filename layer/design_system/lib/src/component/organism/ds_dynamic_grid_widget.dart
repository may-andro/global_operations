import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DSDynamicGridWidget extends StatelessWidget {
  const DSDynamicGridWidget({
    super.key,
    required this.count,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.physics,
    this.shrinkWrap = false,
  });

  final int count;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int crossAxisCount;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: context.space(),
      crossAxisSpacing: context.space(),
      padding: EdgeInsets.all(context.space()),
      itemCount: count,
      itemBuilder: itemBuilder,
      physics: physics,
      shrinkWrap: shrinkWrap,
    );
  }
}

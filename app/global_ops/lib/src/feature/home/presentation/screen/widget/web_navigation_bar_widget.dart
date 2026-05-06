import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/developer_setting/developer_setting.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/bloc.dart';

class WebNavigationBarWidget extends StatelessWidget {
  const WebNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorPalette.background.primary.color,
        border: Border(
          right: BorderSide(color: context.colorPalette.neutral.grey3.color),
        ),
      ),
      child: NavigationRail(
        backgroundColor: context.colorPalette.neutral.transparent.color,
        destinations: [
          NavigationRailDestination(
            icon: _NavigationIcon(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              isSelected: selectedIndex == 0,
            ),
            label: _NavigationLabel(
              text: 'Home',
              isSelected: selectedIndex == 0,
            ),
          ),
          NavigationRailDestination(
            icon: _NavigationIcon(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              isSelected: selectedIndex == 1,
            ),
            label: _NavigationLabel(
              text: 'Settings',
              isSelected: selectedIndex == 1,
            ),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: context.isDesktop
            ? NavigationRailLabelType.all
            : NavigationRailLabelType.selected,
        minWidth: context.space(factor: 10),
        minExtendedWidth: context.space(factor: 20),
        leading: context.isDesktop ? _NavigationHeader() : null,
        trailing: context.isDesktop ? _NavigationFooter() : null,
        groupAlignment: -0.8,
        selectedIconTheme: IconThemeData(
          color: context.colorPalette.brand.primary.color,
          size: context.space(factor: 2.25),
        ),
        unselectedIconTheme: IconThemeData(
          color: context.colorPalette.neutral.grey6.color,
          size: context.space(factor: 1.75),
        ),
        selectedLabelTextStyle: context.typography.labelMedium.textStyle
            .copyWith(
              color: context.colorPalette.brand.primary.color,
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelTextStyle: context.typography.labelMedium.textStyle
            .copyWith(
              color: context.colorPalette.neutral.grey6.color,
              fontWeight: FontWeight.w500,
            ),
        indicatorColor: context.colorPalette.brand.primary.color.withAlpha(30),
        indicatorShape: _PaddedIndicatorShape(
          padding: EdgeInsets.symmetric(vertical: context.space(factor: 2)),
          borderRadius: BorderRadius.circular(context.dimen.radiusLevel2.value),
        ),
      ),
    );
  }
}

class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
  });

  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 200.milliseconds,
      child: Icon(isSelected ? selectedIcon : icon, key: ValueKey(isSelected)),
    );
  }
}

class _NavigationLabel extends StatelessWidget {
  const _NavigationLabel({required this.text, required this.isSelected});

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: 200.milliseconds,
      style: isSelected
          ? context.typography.labelMedium.textStyle.copyWith(
              color: context.colorPalette.brand.primary.color,
              fontWeight: FontWeight.w600,
            )
          : context.typography.labelMedium.textStyle.copyWith(
              color: context.colorPalette.neutral.grey6.color,
              fontWeight: FontWeight.w500,
            ),
      child: Text(text),
    );
  }
}

class _NavigationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.space(factor: 3)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return GestureDetector(
                child: DSIconLogoImageWidget(size: context.space(factor: 7)),
                onTap: () {
                  if (state.isDeveloperModeEnabled) {
                    DeveloperMenuScreen.navigate(context);
                    return;
                  }
                  context.read<HomeBloc>().add(const LogoTappedEvent());
                },
              );
            },
          ),
          SizedBox(height: context.space(factor: 2)),
        ],
      ),
    );
  }
}

class _NavigationFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(context.space(factor: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.space(factor: 2),
                vertical: context.space(factor: 1.5),
              ),
              decoration: BoxDecoration(
                color: context.colorPalette.semantic.info.color.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.colorPalette.semantic.info.color.withAlpha(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 20,
                    color: context.colorPalette.semantic.info.color,
                  ),
                  SizedBox(height: context.space(factor: 0.5)),
                  DSTextWidget(
                    'Help & Support',
                    style: context.typography.labelSmall,
                    color: context.colorPalette.semantic.info,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.space(factor: 2)),
          ],
        ),
      ),
    );
  }
}

// Custom shape with padding for the indicator
class _PaddedIndicatorShape extends ShapeBorder {
  const _PaddedIndicatorShape({
    required this.padding,
    required this.borderRadius,
  });

  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  EdgeInsetsGeometry get dimensions => padding;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(padding.horizontal),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final innerRect = padding.deflateRect(rect);
    return Path()..addRRect(borderRadius.toRRect(innerRect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

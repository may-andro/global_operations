import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class MobileNavigationBarWidget extends StatelessWidget {
  const MobileNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorPalette.background.primary.color,
        boxShadow: [
          BoxShadow(
            color: context.colorPalette.neutral.black.color.withAlpha(10),
            blurRadius: context.space(),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: context.space(factor: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationItem(
                icon: Icons.home_rounded,
                isSelected: selectedIndex == 0,
                onTap: () => onItemTapped(0),
                context: context,
              ),
              _NavigationItem(
                icon: Icons.settings_rounded,
                isSelected: selectedIndex == 1,
                onTap: () => onItemTapped(1),
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.context,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: context.space(factor: 2),
          vertical: context.space(factor: 0.5),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorPalette.brand.primary.color.withAlpha(50)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(context.dimen.radiusLevel3.value),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: 200.ms,
              curve: Curves.easeInOut,
              child: DSIconWidget(
                icon,
                size: DSIconSize.medium,
                color: isSelected
                    ? context.colorPalette.brand.primary
                    : context.colorPalette.neutral.grey9,
              ),
            ),
            if (isSelected) ...[
              SizedBox(height: context.space(factor: 0.5)),
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: 200.ms,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colorPalette.brand.primary.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

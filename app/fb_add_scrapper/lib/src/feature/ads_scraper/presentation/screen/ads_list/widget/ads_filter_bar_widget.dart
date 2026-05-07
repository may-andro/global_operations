import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsFilterActionWidget extends StatelessWidget {
  const AdsFilterActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsListBloc, AdsListState>(
      buildWhen: (prev, curr) => prev.filter != curr.filter,
      builder: (context, state) {
        final activeCount = _activeCount(state.filter);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: DSIconWidget(
                Icons.tune_rounded,
                size: DSIconSize.medium,
                color: activeCount > 0
                    ? context.colorPalette.brand.primary
                    : context.colorPalette.background.onPrimary,
              ),
              onPressed: () => _showFilterSheet(context, state),
            ),
            if (activeCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: context.space(factor: 1.5),
                  height: context.space(factor: 1.5),
                  decoration: BoxDecoration(
                    color: context.colorPalette.brand.primary.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: DSTextWidget(
                      '$activeCount',
                      color: context.colorPalette.brand.onPrimary,
                      style: context.typography.labelSmall,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Active badges bar — shown below app bar only when filters are active
// ---------------------------------------------------------------------------

class AdsFilterBarWidget extends StatelessWidget {
  const AdsFilterBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsListBloc, AdsListState>(
      buildWhen: (prev, curr) => prev.filter != curr.filter,
      builder: (context, state) {
        final filter = state.filter;
        if (!filter.isActive) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.space(factor: 2),
                vertical: context.space(factor: 0.75),
              ),
              child: Row(
                children: [
                  ..._badges(context, filter),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.read<AdsListBloc>().add(
                      const FilterAdsListEvent(clearAll: true),
                    ),
                    child: DSTextWidget(
                      'Clear all',
                      color: context.colorPalette.semantic.error,
                      style: context.typography.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
            DSHorizontalDividerWidget(
              thickness: 1,
              color: context.colorPalette.neutral.grey8,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _badges(BuildContext context, AdsListFilter filter) {
    final badges = <Widget>[];
    void add(String label, VoidCallback onRemove) {
      badges.add(_ActiveBadge(label: label, onRemove: onRemove));
      badges.add(SizedBox(width: context.space(factor: 0.5)));
    }

    if (filter.platform != null) {
      add(
        _capitalise(filter.platform!.replaceAll('_', ' ')),
        () => context.read<AdsListBloc>().add(
          FilterAdsListEvent(
            gender: filter.gender,
            deliveryStatus: filter.deliveryStatus,
          ),
        ),
      );
    }
    if (filter.gender != null) {
      add(
        filter.gender!,
        () => context.read<AdsListBloc>().add(
          FilterAdsListEvent(
            platform: filter.platform,
            deliveryStatus: filter.deliveryStatus,
          ),
        ),
      );
    }
    if (filter.deliveryStatus != null) {
      add(
        _capitalise(filter.deliveryStatus!),
        () => context.read<AdsListBloc>().add(
          FilterAdsListEvent(platform: filter.platform, gender: filter.gender),
        ),
      );
    }
    return badges;
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

// ---------------------------------------------------------------------------
// Active filter badge pill
// ---------------------------------------------------------------------------

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space(factor: 0.75),
        vertical: context.space(factor: 0.2),
      ),
      decoration: BoxDecoration(
        color: context.colorPalette.brand.primary.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.dimen.radiusLevel3.value),
        border: Border.all(
          color: context.colorPalette.brand.primary.color.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DSTextWidget(
            label,
            color: context.colorPalette.brand.primary,
            style: context.typography.labelSmall,
          ),
          SizedBox(width: context.space(factor: 0.3)),
          GestureDetector(
            onTap: onRemove,
            child: DSIconWidget(
              Icons.close_rounded,
              size: DSIconSize.small,
              color: context.colorPalette.brand.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Show filter bottom sheet (shared helper)
// ---------------------------------------------------------------------------

void _showFilterSheet(BuildContext context, AdsListState state) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<AdsListBloc>(),
      child: const _FilterSheet(),
    ),
  );
}

int _activeCount(AdsListFilter filter) {
  int count = 0;
  if (filter.platform != null) count++;
  if (filter.gender != null) count++;
  if (filter.deliveryStatus != null) count++;
  return count;
}

// ---------------------------------------------------------------------------
// Bottom sheet content
// ---------------------------------------------------------------------------

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return DSBottomSheetWidget(
      child: BlocBuilder<AdsListBloc, AdsListState>(
        buildWhen: (prev, curr) => prev.filter != curr.filter,
        builder: (context, state) {
          final filter = state.filter;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DSTextWidget(
                    'Filters',
                    color: context.colorPalette.background.onPrimary,
                    style: context.typography.titleMedium,
                  ),
                  const Spacer(),
                  if (filter.isActive)
                    TextButton(
                      onPressed: () {
                        context.read<AdsListBloc>().add(
                          const FilterAdsListEvent(clearAll: true),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clear all',
                        style: context.typography.labelMedium.textStyle
                            .copyWith(
                              color: context.colorPalette.semantic.error.color,
                            ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: context.space(factor: 1.5)),
              _SheetSection(
                label: 'Platform',
                options: const [
                  ('Facebook', 'facebook'),
                  ('Instagram', 'instagram'),
                  ('Messenger', 'messenger'),
                  ('Audience Network', 'audience_network'),
                ],
                selected: filter.platform,
                onSelected: (value) {
                  final next = filter.platform == value ? null : value;
                  context.read<AdsListBloc>().add(
                    FilterAdsListEvent(
                      platform: next,
                      gender: filter.gender,
                      deliveryStatus: filter.deliveryStatus,
                    ),
                  );
                },
              ),
              SizedBox(height: context.space(factor: 1.5)),
              _SheetSection(
                label: 'Gender',
                options: const [
                  ('Men', 'Men'),
                  ('Women', 'Women'),
                  ('All', 'All'),
                ],
                selected: filter.gender,
                onSelected: (value) {
                  final next = filter.gender == value ? null : value;
                  context.read<AdsListBloc>().add(
                    FilterAdsListEvent(
                      platform: filter.platform,
                      gender: next,
                      deliveryStatus: filter.deliveryStatus,
                    ),
                  );
                },
              ),
              SizedBox(height: context.space(factor: 1.5)),
              _SheetSection(
                label: 'Delivery status',
                options: const [('Active', 'active'), ('Stopped', 'stopped')],
                selected: filter.deliveryStatus,
                onSelected: (value) {
                  final next = filter.deliveryStatus == value ? null : value;
                  context.read<AdsListBloc>().add(
                    FilterAdsListEvent(
                      platform: filter.platform,
                      gender: filter.gender,
                      deliveryStatus: next,
                    ),
                  );
                },
              ),
              SizedBox(height: context.space(factor: 2)),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet section: label + Wrap of chips
// ---------------------------------------------------------------------------

class _SheetSection extends StatelessWidget {
  const _SheetSection({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<(String, String)> options;
  final String? selected;
  final void Function(String value) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSTextWidget(
          label,
          color: context.colorPalette.background.onPrimary,
          style: context.typography.labelSmall,
        ),
        SizedBox(height: context.space(factor: 0.5)),
        Wrap(
          spacing: context.space(factor: 0.75),
          runSpacing: context.space(factor: 0.5),
          children: options.map((opt) {
            final (labelText, value) = opt;
            final isSelected = selected == value;
            final activeColor = context.colorPalette.brand.primary;
            return FilterChip(
              label: DSTextWidget(
                labelText,
                color: isSelected
                    ? context.colorPalette.brand.onPrimary
                    : context.colorPalette.neutral.grey6,
                style: context.typography.labelMedium,
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(value),
              selectedColor: activeColor.color,
              backgroundColor: context.colorPalette.neutral.grey4.color,
              checkmarkColor: context.colorPalette.brand.onPrimary.color,
              side: BorderSide(
                color: isSelected
                    ? activeColor.color
                    : context.colorPalette.invertedBackground.primary.color,
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}

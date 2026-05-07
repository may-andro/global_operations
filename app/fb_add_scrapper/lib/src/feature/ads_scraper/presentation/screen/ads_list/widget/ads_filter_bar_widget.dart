import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsFilterBarWidget extends StatelessWidget {
  const AdsFilterBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsListBloc, AdsListState>(
      buildWhen: (prev, curr) => prev.filter != curr.filter,
      builder: (context, state) {
        final filter = state.filter;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: context.space(factor: 2),
            vertical: context.space(factor: 0.5),
          ),
          child: Row(
            children: [
              // ── Platform ──
              _FilterChipGroup<String>(
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
              SizedBox(width: context.space()),

              // ── Gender ──
              _FilterChipGroup<String>(
                label: 'Gender',
                options: const [
                  ('Men', 'Men'),
                  ('Women', 'Women'),
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
              SizedBox(width: context.space()),

              // ── Delivery ──
              _FilterChipGroup<String>(
                label: 'Status',
                options: const [
                  ('Active', 'active'),
                  ('Stopped', 'stopped'),
                ],
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

              // ── Clear all ──
              if (filter.isActive) ...[
                SizedBox(width: context.space()),
                ActionChip(
                  label: DSTextWidget(
                    'Clear',
                    color: context.colorPalette.semantic.error,
                    style: context.typography.labelMedium,
                  ),
                  avatar: DSIconWidget(
                    Icons.close_rounded,
                    size: DSIconSize.small,
                    color: context.colorPalette.semantic.error,
                  ),
                  backgroundColor:
                      context.colorPalette.semantic.errorContainer.color
                          .withValues(alpha: 0.15),
                  side: BorderSide(
                    color: context.colorPalette.semantic.error.color
                        .withValues(alpha: 0.4),
                  ),
                  onPressed: () => context
                      .read<AdsListBloc>()
                      .add(const FilterAdsListEvent(clearAll: true)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _FilterChipGroup<T> extends StatelessWidget {
  const _FilterChipGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<(String, T)> options;
  final T? selected;
  final void Function(T value) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.map((opt) {
        final (labelText, value) = opt;
        final isSelected = selected == value;
        final activeColor = context.colorPalette.brand.primary;
        return Padding(
          padding: EdgeInsets.only(right: context.space(factor: 0.5)),
          child: FilterChip(
            label: DSTextWidget(
              labelText,
              color: isSelected
                  ? context.colorPalette.brand.onPrimary
                  : context.colorPalette.neutral.grey3,
              style: context.typography.labelMedium,
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(value),
            selectedColor: activeColor.color,
            backgroundColor:
                context.colorPalette.invertedBackground.surface.color,
            checkmarkColor:
                context.colorPalette.brand.onPrimary.color,
            side: BorderSide(
              color: isSelected
                  ? activeColor.color
                  : context.colorPalette.neutral.grey7.color,
            ),
            showCheckmark: false,
          ),
        );
      }).toList(),
    );
  }
}


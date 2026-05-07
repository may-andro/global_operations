import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Top section card: search-bar styled input + ad-type button + add button
/// + result count. Mirrors FilterSectionWidget from paginated_ad_panels.
class FilterSectionWidget extends StatefulWidget {
  const FilterSectionWidget({super.key});

  @override
  State<FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<FilterSectionWidget> {
  final _controller = TextEditingController();
  String _adType = 'ALL';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAdd() {
    final term = _controller.text.trim();
    if (term.isEmpty) return;
    context.read<AdsSearchBloc>().add(
          AddSearchTermEvent(searchTerms: term, adType: _adType),
        );
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsSearchBloc, AdsSearchState>(
      buildWhen: (p, c) => c is AdsSearchLoadedState,
      builder: (context, state) {
        if (state is! AdsSearchLoadedState) return const SizedBox.shrink();
        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, AdsSearchLoadedState state) {
    return DsCardWidget(
      backgroundColor: context.colorPalette.background.primary,
      elevation: context.isDesktop ? null : context.dimen.elevationLevel3,
      radius: context.isDesktop ? null : context.dimen.radiusLevel3,
      child: Padding(
        padding: EdgeInsets.only(
          left: context.space(factor: 2),
          right: context.space(factor: 2),
          top: context.space(factor: context.isDesktop ? 1 : 0),
          bottom: context.space(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Search bar row ──
            Row(
              children: [
                Expanded(
                  child: _SearchInputWidget(
                    controller: _controller,
                    onSubmitted: _onAdd,
                  ),
                ),
                _AdTypeButtonWidget(
                  selected: _adType,
                  onSelected: (v) => setState(() => _adType = v),
                ),
                AnimatedSwitcher(
                  duration: 200.ms,
                  child: state.isAdding
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: context.space(factor: 5),
                          height: context.space(factor: 5),
                          child: Padding(
                            padding: EdgeInsets.all(context.space(factor: 0.75)),
                            child: DSLoadingWidget(size: context.space(factor: 3)),
                          ),
                        )
                      : DSIconButtonWidget(
                          key: const ValueKey('add'),
                          Icons.add_rounded,
                          iconColor: context.colorPalette.brand.onPrimary,
                          buttonColor: context.colorPalette.brand.primary,
                          size: DSIconButtonSize.medium,
                          onPressed: _onAdd,
                        ),
                ),
              ],
            ),
            // ── Error message ──
            if (state.addError != null) ...[
              DSVerticalSpacerWidget(1),
              DSTextWidget(
                state.addError!,
                style: context.typography.labelSmall,
                color: context.colorPalette.semantic.error,
              ),
            ],
            DSVerticalSpacerWidget(1),
            // ── Result count ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DSTextWidget(
                  '${state.terms.length} term${state.terms.length == 1 ? '' : 's'}',
                  style: context.typography.labelSmall,
                  color: context.colorPalette.background.onPrimary,
                ),
                DSTextWidget(
                  _adType == 'ALL' ? 'All ads' : 'Political & Issue',
                  style: context.typography.labelSmall,
                  color: context.colorPalette.background.onPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search-bar styled input
// ---------------------------------------------------------------------------

class _SearchInputWidget extends StatelessWidget {
  const _SearchInputWidget({
    required this.controller,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        hintText: 'Search ads...',
        prefixIcon: const Icon(Icons.search_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimen.radiusLevel2.value),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.space(factor: 1.5),
          vertical: context.space(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ad-type icon button
// ---------------------------------------------------------------------------

class _AdTypeButtonWidget extends StatelessWidget {
  const _AdTypeButtonWidget({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    final isFiltered = selected != 'ALL';
    return IconButton(
      icon: DSIconWidget(
        isFiltered ? Icons.how_to_vote_rounded : Icons.tune_rounded,
        color: isFiltered
            ? context.colorPalette.brand.primary
            : context.colorPalette.background.onPrimary,
        size: DSIconSize.medium,
      ),
      onPressed: () async {
        final option = await _showOptions(context, selected);
        if (option != null) onSelected(option);
      },
    );
  }

  Future<String?> _showOptions(BuildContext context, String current) {
    final content = _AdTypeOptionsWidget(selected: current);
    if (context.isDesktop) {
      return showDialog<String>(
        context: context,
        builder: (_) => DSDialogWidget(child: content),
      );
    }
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DSBottomSheetWidget(child: content),
    );
  }
}

class _AdTypeOptionsWidget extends StatelessWidget {
  const _AdTypeOptionsWidget({required this.selected});

  final String selected;

  static const _options = [
    ('ALL', 'All Ads', Icons.layers_rounded),
    ('POLITICAL_AND_ISSUE_ADS', 'Political & Issue', Icons.how_to_vote_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DSVerticalSpacerWidget(1),
          DSTextWidget(
            'Ad Type',
            style: context.typography.titleMedium,
            color: context.colorPalette.background.onPrimary,
          ),
          DSVerticalSpacerWidget(2),
          ..._options.map((o) {
            final isSelected = o.$1 == selected;
            final color = isSelected
                ? context.colorPalette.brand.primary
                : context.colorPalette.background.onPrimary;
            return ListTile(
              leading: DSCircularIconCardWidget(
                icon: o.$3,
                color: isSelected
                    ? context.colorPalette.brand.onPrimary
                    : context.colorPalette.invertedBackground.onPrimary,
                backgroundColor: isSelected
                    ? context.colorPalette.brand.primary
                    : context.colorPalette.invertedBackground.primary,
              ),
              title: DSTextWidget(
                o.$2,
                style: context.typography.titleSmall,
                color: color,
              ),
              onTap: () => Navigator.pop(context, o.$1),
            );
          }),
        ],
      ),
    );
  }
}

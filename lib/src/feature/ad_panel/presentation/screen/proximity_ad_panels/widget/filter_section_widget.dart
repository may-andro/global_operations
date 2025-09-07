import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/widget/radius_button_widget.dart';

const List<AdPanelSortOption> _sortOptions = [
  DistanceSortOption(),
  LastEditedSortOption(),
  ObjectNumberSortOption(),
  StreetSortOption(),
];

class FilterSectionWidget extends StatefulWidget {
  const FilterSectionWidget({super.key});

  @override
  State<FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<FilterSectionWidget> {
  late TextEditingController _searchController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Updates search controller text if needed
  void _updateSearchController(String searchQuery) {
    if (_searchController.text != searchQuery) {
      final cursorPosition = _searchController.selection.baseOffset;
      _searchController.text = searchQuery;
      _searchController.selection = TextSelection.collapsed(
        offset: cursorPosition.clamp(0, searchQuery.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProximityAdPanelsBloc, ProximityAdPanelsState>(
      listener: (context, state) {
        if (state is AdPanelsLoadedState) {
          _updateSearchController(state.searchQuery);
          if (_searchController.text.isNotEmpty) {
            //FocusScope.of(context).requestFocus(_focusNode);
          }
        }
      },
      builder: (context, state) {
        final currentState = state;

        // Only render if in loaded state
        if (currentState is! AdPanelsLoadedState) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, currentState);
      },
    );
  }

  Widget _buildContent(BuildContext context, AdPanelsLoadedState state) {
    // Ensure the controller has the correct text
    _updateSearchController(state.searchQuery);

    final resultCount = state.filteredAdPanelsMap.entries.length;

    return DsCardWidget(
      backgroundColor: context.colorPalette.background.primary,
      elevation: context.isDesktop ? null : context.dimen.elevationLevel3,
      radius: context.isDesktop ? null : context.dimen.radiusLevel3,
      child: Padding(
        padding: EdgeInsets.only(
          right: context.space(factor: 2),
          left: context.space(factor: 2),
          bottom: context.space(),
          top: context.space(factor: context.isDesktop ? 1 : 0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.isSearchFieldAvailable) ...[
              _buildSearchAndSortRow(state),
              const DSVerticalSpacerWidget(1),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ResultCountWidget(
                  count: resultCount,
                  radiusInKm: state.radiusInKm,
                ),
                Icon(
                  resultCount == 0
                      ? Icons.not_interested_rounded
                      : Icons.done_all,
                  color: state.isRefreshing
                      ? context.colorPalette.background.primary.color
                      : context.colorPalette.background.onPrimary.color,
                  size: context.getTextHeight(context.typography.labelSmall, 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search bar and sort button row
  Widget _buildSearchAndSortRow(AdPanelsLoadedState state) {
    final sortOption = state.sortOption ?? _sortOptions.first;
    return Row(
      children: [
        Expanded(
          child: SearchWidget(
            searchController: _searchController,
            focusNode: _focusNode,
            searchQuery: state.searchQuery,
            onSearch: (value) {
              context.read<ProximityAdPanelsBloc>().add(
                UpdateSearchQueryEvent(value),
              );
            },
            isEnabled: !state.isRefreshing,
          ),
        ),
        RadiusButtonWidget(
          selected: state.radiusInKm,
          onSelected: (radiusInKm) {
            context.read<ProximityAdPanelsBloc>().add(
              UpdateSearchRadiusEvent(radiusInKm),
            );
          },
          isEnabled: !state.isRefreshing,
        ),
        SortButtonWidget(
          selected: sortOption,
          sortOptions: _sortOptions,
          onSelected: (sortOption) {
            context.read<ProximityAdPanelsBloc>().add(
              UpdateSortOptionEvent(sortOption),
            );
          },
          isVisible: state.viewType.isListType && state.isSortButtonAvailable,
          isEnabled: !state.isRefreshing,
        ),
      ],
    );
  }
}

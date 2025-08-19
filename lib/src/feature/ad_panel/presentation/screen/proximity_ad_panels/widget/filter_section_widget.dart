import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/widget/radius_slider_widget.dart';

class FilterSectionWidget extends StatefulWidget {
  const FilterSectionWidget({super.key, required this.isEnabled});

  final bool isEnabled;

  @override
  State<FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<FilterSectionWidget> {
  late TextEditingController _searchController;

  final List<AdPanelSortOption> _sortOptions = const [
    DistanceSortOption(),
    LastEditedSortOption(),
    ObjectNumberSortOption(),
    StreetSortOption(),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Extracts search query from the current state
  String _getSearchQuery(ProximityAdPanelsState state) {
    if (state is AdPanelsLoadedState) {
      return state.searchQuery;
    }
    return '';
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

  /// Checks if widget should be visible based on state
  bool _shouldShowWidget(ProximityAdPanelsState state) {
    return state is AdPanelsLoadedState || state is AdPanelsListLoadingState;
  }

  /// Gets the loaded state from current state
  AdPanelsLoadedState? _getLoadedState(ProximityAdPanelsState state) {
    return switch (state) {
      AdPanelsLoadedState() => state,
      AdPanelsListLoadingState() => state.previousState,
      _ => null,
    };
  }

  /// Extracts filter values from the current state
  ({
    String searchQuery,
    AdPanelSortOption sortOption,
    AdPanelViewType viewType,
    double radiusInKm,
    int resultCount,
  })
  _extractFilterData(ProximityAdPanelsState state) {
    final loadedState = _getLoadedState(state);

    final searchQuery = loadedState?.searchQuery ?? '';

    final sortOption = loadedState?.sortOption ?? _sortOptions.first;

    final viewType = loadedState?.viewType ?? AdPanelViewType.list;

    final radiusInKm = loadedState?.radiusInKm ?? 5.0;

    final resultCount = loadedState?.filteredAdPanelsMap.entries.length ?? 0;

    return (
      searchQuery: searchQuery,
      sortOption: sortOption,
      viewType: viewType,
      radiusInKm: radiusInKm,
      resultCount: resultCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProximityAdPanelsBloc, ProximityAdPanelsState>(
      listener: (context, state) {
        final searchQuery = _getSearchQuery(state);
        _updateSearchController(searchQuery);
      },
      builder: (context, state) {
        if (!_shouldShowWidget(state)) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, state);
      },
    );
  }

  /// Builds the main content widget
  Widget _buildContent(BuildContext context, ProximityAdPanelsState state) {
    final filterData = _extractFilterData(state);

    // Ensure the controller has the correct text
    _updateSearchController(filterData.searchQuery);

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
            _buildSearchAndSortRow(filterData),
            RadiusSliderWidget(isEnabled: widget.isEnabled),
            ResultCountWidget(
              count: filterData.resultCount,
              radiusInKm: filterData.radiusInKm,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search bar and sort button row
  Widget _buildSearchAndSortRow(
    ({
      String searchQuery,
      AdPanelSortOption sortOption,
      AdPanelViewType viewType,
      double radiusInKm,
      int resultCount,
    })
    filterData,
  ) {
    return Row(
      children: [
        Expanded(
          child: SearchWidget(
            searchController: _searchController,
            searchQuery: filterData.searchQuery,
            onSearch: (value) {
              context.read<ProximityAdPanelsBloc>().add(
                UpdateSearchQueryEvent(value),
              );
            },
            isEnabled: widget.isEnabled,
          ),
        ),
        SortButtonWidget(
          selected: filterData.sortOption,
          sortOptions: _sortOptions,
          onSelected: (sortOption) {
            context.read<ProximityAdPanelsBloc>().add(
              UpdateSortOptionEvent(sortOption),
            );
          },
          isVisible: filterData.viewType.isListType,
          isEnabled: widget.isEnabled,
        ),
      ],
    );
  }
}

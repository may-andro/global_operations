import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/widget/filter_button_widget.dart';

const List<AdPanelSortOption> _sortOptions = [
  LastEditedSortOption(),
  ObjectNumberSortOption(),
  StreetSortOption(),
];

class FilterSectionWidget extends StatefulWidget {
  const FilterSectionWidget({super.key, required this.isEnabled});

  final bool isEnabled;

  @override
  State<FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<FilterSectionWidget> {
  late final TextEditingController _searchController;
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
    return BlocConsumer<PaginatedAdPanelsBloc, PaginatedAdPanelsState>(
      listener: (context, state) {
        if (state is AdPanelsLoadedState) {
          _updateSearchController(state.searchQuery);
          if (_searchController.text.isNotEmpty) {
            //FocusScope.of(context).requestFocus(_focusNode);
          }
        }
      },
      builder: (context, state) {
        if (!state.shouldShowWidget) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, PaginatedAdPanelsState state) {
    final filterData = state.extractFilterData;

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
            const DSVerticalSpacerWidget(1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ResultCountWidget(count: filterData.resultCount),
                Icon(
                  filterData.resultCount == 0
                      ? Icons.not_interested_rounded
                      : filterData.hasMoreData
                      ? Icons.unfold_more_rounded
                      : Icons.done_all,
                  color: widget.isEnabled
                      ? context.colorPalette.background.onPrimary.color
                      : context.colorPalette.background.primary.color,
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
  Widget _buildSearchAndSortRow(
    ({
      String searchQuery,
      AdPanelSortOption sortOption,
      AdPanelFilterOption filterOption,
      AdPanelViewType viewType,
      int resultCount,
      bool hasMoreData,
    })
    filterData,
  ) {
    return Row(
      children: [
        Expanded(
          child: SearchWidget(
            hintText: filterData.filterOption.searchHintText(context),
            searchController: _searchController,
            focusNode: _focusNode,
            searchQuery: filterData.searchQuery,
            onSearch: (value) {
              context.bloc.add(UpdateSearchQueryEvent(value));
            },
            isEnabled: widget.isEnabled,
          ),
        ),
        FilterButtonWidget(
          selected: filterData.filterOption,
          onSelected: (filterOption) {
            context.bloc.add(UpdateFilterOptionEvent(filterOption));
          },
          isVisible: true,
          isEnabled: widget.isEnabled,
        ),
        SortButtonWidget(
          selected: filterData.sortOption,
          sortOptions: _sortOptions,
          onSelected: (sortOption) {
            context.bloc.add(UpdateSortOptionEvent(sortOption));
          },
          isVisible: filterData.viewType.isListType,
          isEnabled: widget.isEnabled,
        ),
      ],
    );
  }
}

extension on PaginatedAdPanelsState {
  /// Checks if widget should be visible based on state
  bool get shouldShowWidget {
    return this is AdPanelsLoadedState;
  }

  /// Extracts filter values from the current state
  ({
    String searchQuery,
    AdPanelSortOption sortOption,
    AdPanelFilterOption filterOption,
    AdPanelViewType viewType,
    int resultCount,
    bool hasMoreData,
  })
  get extractFilterData {
    final loadedState = _getLoadedState;

    final searchQuery = loadedState?.searchQuery ?? '';

    final sortOption = loadedState?.sortOption ?? _sortOptions.first;

    final filterOption =
        loadedState?.filterOption ?? const ObjectNumberFilterOption();

    final viewType = loadedState?.viewType ?? AdPanelViewType.list;

    final resultCount = loadedState?.filteredAdPanelsMap.entries.length ?? 0;

    final hasMoreData = loadedState?.hasMoreData ?? true;

    return (
      searchQuery: searchQuery,
      sortOption: sortOption,
      filterOption: filterOption,
      viewType: viewType,
      resultCount: resultCount,
      hasMoreData: hasMoreData,
    );
  }

  /// Gets the loaded state from current state
  AdPanelsLoadedState? get _getLoadedState {
    return switch (this) {
      final AdPanelsLoadedState state => state,
      _ => null,
    };
  }
}

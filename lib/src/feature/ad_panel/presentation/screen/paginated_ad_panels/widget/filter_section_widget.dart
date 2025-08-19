import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';

class FilterSectionWidget extends StatefulWidget {
  const FilterSectionWidget({super.key});

  @override
  State<FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<FilterSectionWidget> {
  late TextEditingController _searchController;

  final List<AdPanelSortOption> _sortOptions = const [
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaginatedAdPanelsBloc, PaginatedAdPanelsState>(
      listener: (context, state) {
        if (state is AdPanelsLoadedState) {
          if (_searchController.text != state.searchQuery) {
            final cursorPosition = _searchController.selection.baseOffset;
            _searchController.text = state.searchQuery;
            _searchController.selection = TextSelection.collapsed(
              offset: cursorPosition.clamp(0, state.searchQuery.length),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is! AdPanelsLoadedState) {
          return const SizedBox.shrink();
        }
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
                Row(
                  children: [
                    Expanded(
                      child: SearchWidget(
                        searchController: _searchController,
                        searchQuery: state.searchQuery,
                        onSearch: (value) {
                          context.read<PaginatedAdPanelsBloc>().add(
                            UpdateSearchQueryEvent(value),
                          );
                        },
                      ),
                    ),
                    SortButtonWidget(
                      selected: state.sortOption ?? _sortOptions.first,
                      sortOptions: _sortOptions,
                      onSelected: (sortOption) {
                        context.read<PaginatedAdPanelsBloc>().add(
                          UpdateSortOptionEvent(sortOption),
                        );
                      },
                      isVisible: state.viewType.isListType,
                    ),
                  ],
                ),
                const DSVerticalSpacerWidget(0.5),
                ResultCountWidget(
                  count: state.filteredAdPanelsMap.entries.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

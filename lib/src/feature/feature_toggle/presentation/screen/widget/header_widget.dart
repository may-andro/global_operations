import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/bloc.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
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
    return BlocConsumer<FeatureToggleBloc, FeatureToggleState>(
      listener: (context, state) {
        if (state is FeatureToggleLoadedState) {
          _updateSearchController(state.searchQuery);
          if (_searchController.text.isNotEmpty) {
            //FocusScope.of(context).requestFocus(_focusNode);
          }
        }
      },
      builder: (context, state) {
        if (state is FeatureToggleLoadedState) {
          return _buildContent(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(BuildContext context, FeatureToggleLoadedState state) {
    final searchQuery = state.searchQuery;
    final resultCount = state.filteredFeatureFlags.length;
    final isRestartNeeded = state.isRestartNeeded;

    // Ensure the controller has the correct text
    _updateSearchController(searchQuery);

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
                  child: _SearchWidget(
                    searchController: _searchController,
                    focusNode: _focusNode,
                    searchQuery: searchQuery,
                    onSearch: (value) {
                      context.bloc.add(UpdateSearchQueryEvent(value));
                    },
                    isEnabled:
                        state.featureFlags.isNotEmpty || searchQuery.isNotEmpty,
                  ),
                ),
                if (context.isDesktop) ...[
                  const DSHorizontalSpacerWidget(1),
                  if (state.filteredFeatureFlags.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        state.isGridView ? Icons.view_list : Icons.grid_view,
                      ),
                      onPressed: () =>
                          context.bloc.add(UpdateListViewTypeEvent()),
                    ),
                  const DSHorizontalSpacerWidget(1),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.bloc.add(const ResetFFEvent()),
                  ),
                ],
              ],
            ),
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              'Feature Toggles $resultCount',
              style: context.typography.labelSmall,
              color: context.colorPalette.background.onPrimary,
            ),
            _RestartAppTileWidget(isRestartNeeded),
          ],
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    required this.searchController,
    required this.searchQuery,
    required this.onSearch,
    this.isEnabled = true,
    this.focusNode,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final void Function(String) onSearch;
  final FocusNode? focusNode;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'Search Feature Flags',
        //context.l10n.searchFeatureFlags,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => onSearch(''),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: onSearch,
      enabled: isEnabled,
    );
  }
}

class _RestartAppTileWidget extends StatelessWidget {
  const _RestartAppTileWidget(this.isRestartNeeded);

  final bool isRestartNeeded;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Row(
        children: <Widget>[
          Icon(
            Icons.restart_alt_rounded,
            size: context.getTextHeight(context.typography.labelMedium, 1),
          ),
          const DSHorizontalSpacerWidget(0.5),
          Expanded(
            child: DSTextWidget(
              'Restart maybe required to apply changes',
              color: context.colorPalette.neutral.grey9,
              style: context.typography.labelMedium,
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          const DSHorizontalSpacerWidget(2),
          DSButtonWidget(
            label: 'Restart',
            size: DSButtonSize.small,
            variant: DSButtonVariant.text,
            onPressed: () => context.bloc.add(RestartAppEvent()),
          ),
        ],
      ),
      secondChild: const SizedBox.shrink(),
      crossFadeState: isRestartNeeded
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      alignment: Alignment.bottomCenter,
      duration: 300.milliseconds,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    required this.searchController,
    required this.searchQuery,
    required this.onSearch,
    this.isEnabled = true,
    super.key,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final void Function(String) onSearch;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: context.localizations.adPanelSearchHint,
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

import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    required this.searchController,
    required this.searchQuery,
    required this.onSearch,
    this.isEnabled = true,
    this.hintText,
    this.focusNode,
    super.key,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final void Function(String) onSearch;
  final bool isEnabled;
  final String? hintText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText ?? context.localizations.adPanelSearchHint,
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

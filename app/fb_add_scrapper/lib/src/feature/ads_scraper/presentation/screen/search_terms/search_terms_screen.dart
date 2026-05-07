import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/route/ads_scraper_module_route.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/search_terms/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchTermsScreen extends StatelessWidget {
  const SearchTermsScreen({super.key});

  static const routeName = '/search-terms';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appServiceLocator.get<SearchTermsBloc>()
        ..add(const WatchSearchTermsEvent()),
      child: const _SearchTermsView(),
    );
  }
}

// ---------------------------------------------------------------------------

class _SearchTermsView extends StatefulWidget {
  const _SearchTermsView();

  @override
  State<_SearchTermsView> createState() => _SearchTermsViewState();
}

class _SearchTermsViewState extends State<_SearchTermsView> {
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
    context.read<SearchTermsBloc>().add(
          AddSearchTermEvent(searchTerms: term, adType: _adType),
        );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorPalette.background.primary.color,
      appBar: AppBar(
        backgroundColor: context.colorPalette.background.primary.color,
        title: const Text('Ad Search Terms'),
      ),
      body: Column(
        children: [
          _AddTermBar(
            controller: _controller,
            adType: _adType,
            onAdTypeChanged: (v) => setState(() => _adType = v),
            onAdd: _onAdd,
          ),
          const Expanded(child: _TermsList()),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Input bar
// ---------------------------------------------------------------------------

class _AddTermBar extends StatelessWidget {
  const _AddTermBar({
    required this.controller,
    required this.adType,
    required this.onAdTypeChanged,
    required this.onAdd,
  });

  final TextEditingController controller;
  final String adType;
  final ValueChanged<String> onAdTypeChanged;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isAdding = context.select(
      (SearchTermsBloc b) => b.state.status == SearchTermsStatus.adding,
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onAdd(),
                  decoration: const InputDecoration(
                    hintText: 'Enter search term...',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              isAdding
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onAdd,
                      child: const Text('Add'),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: adType,
            decoration: const InputDecoration(
              labelText: 'Ad type',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: const [
              DropdownMenuItem(value: 'ALL', child: Text('All')),
              DropdownMenuItem(
                value: 'POLITICAL_AND_ISSUE_ADS',
                child: Text('Political & Issue'),
              ),
            ],
            onChanged: (v) {
              if (v != null) onAdTypeChanged(v);
            },
          ),
          BlocBuilder<SearchTermsBloc, SearchTermsState>(
            buildWhen: (p, c) => c.errorMessage != p.errorMessage,
            builder: (_, state) {
              if (state.errorMessage == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(
                    color: context.colorPalette.status.error.color,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Terms list
// ---------------------------------------------------------------------------

class _TermsList extends StatelessWidget {
  const _TermsList();

  @override
  Widget build(BuildContext context) {
    final terms = context.select((SearchTermsBloc b) => b.state.terms);

    if (terms.isEmpty) {
      return const Center(
        child: Text('No search terms yet.\nAdd one above!',
            textAlign: TextAlign.center),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: terms.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) => _TermTile(term: terms[i]),
    );
  }
}

// ---------------------------------------------------------------------------
// Term tile
// ---------------------------------------------------------------------------

class _TermTile extends StatelessWidget {
  const _TermTile({required this.term});

  final SearchTermEntity term;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      title: Text(term.term, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: term.isDone
          ? Text('${term.totalCount} ads')
          : term.hasError
              ? Text(
                  'Error: ${term.errorMessage ?? "unknown"}',
                  style: TextStyle(
                    color: context.colorPalette.status.error.color,
                  ),
                )
              : null,
      trailing: _StatusBadge(status: term.status),
      onTap: term.isDone
          ? () => context.pushNamed(
                AdsScraperModuleRoute.termAdsList.name,
                pathParameters: {'termId': term.id},
              )
          : null,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SearchTermStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SearchTermStatus.loading:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SearchTermStatus.done:
        return Icon(Icons.check_circle,
            color: context.colorPalette.status.success.color);
      case SearchTermStatus.error:
        return Icon(Icons.error, color: context.colorPalette.status.error.color);
      case SearchTermStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.grey);
    }
  }
}


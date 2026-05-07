import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/ads_detail_screen.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsSearchScreen extends StatelessWidget {
  const AdsSearchScreen({super.key});

  static const routeName = '/ads-scraper';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appServiceLocator.get<AdsScrapeBloc>(),
      child: const _AdsSearchView(),
    );
  }
}

class _AdsSearchView extends StatefulWidget {
  const _AdsSearchView();

  @override
  State<_AdsSearchView> createState() => _AdsSearchViewState();
}

class _AdsSearchViewState extends State<_AdsSearchView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _adType = 'ALL';
  final List<String> _countries = ['NL'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    context.read<AdsScrapeBloc>().add(const LoadSavedAdsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<AdsScrapeBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        state.hasNextPage &&
        !state.isLoading) {
      context.read<AdsScrapeBloc>().add(const LoadMoreAdsEvent());
    }
  }

  void _search() {
    final terms = _searchController.text.trim();
    context.read<AdsScrapeBloc>().add(
      SearchAdsEvent(
        searchTerms: terms,
        countries: _countries,
        adType: _adType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Ads Scraper'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Search'),
            Tab(icon: Icon(Icons.bookmarks), text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSearchTab(), _buildSavedTab()],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        _SearchBar(
          controller: _searchController,
          adType: _adType,
          onAdTypeChanged: (v) => setState(() => _adType = v),
          onSearch: _search,
        ),
        Expanded(
          child: BlocBuilder<AdsScrapeBloc, AdsScrapeState>(
            builder: (context, state) {
              if (state.status == AdsScrapeStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == AdsScrapeStatus.failure) {
                return _ErrorView(message: state.errorMessage);
              }
              if (state.ads.isEmpty &&
                  state.status == AdsScrapeStatus.success) {
                return const Center(child: Text('No ads found.'));
              }
              return _AdsList(
                ads: state.ads,
                scrollController: _scrollController,
                isLoadingMore: state.status == AdsScrapeStatus.loadingMore,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSavedTab() {
    return BlocBuilder<AdsScrapeBloc, AdsScrapeState>(
      builder: (context, state) {
        if (state.savedAds.isEmpty) {
          return const Center(
            child: Text('No saved ads yet.\nSearch and they will auto-save.'),
          );
        }
        return ListView.builder(
          itemCount: state.savedAds.length,
          itemBuilder: (_, i) => _AdTile(
            ad: state.savedAds[i],
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => context
                  .read<AdsScrapeBloc>()
                  .add(DeleteSavedAdEvent(state.savedAds[i].id)),
            ),
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------------------
// Widgets
// --------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.adType,
    required this.onAdTypeChanged,
    required this.onSearch,
  });

  final TextEditingController controller;
  final String adType;
  final ValueChanged<String> onAdTypeChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search terms (leave empty for all)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => onSearch(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Scrape'),
                onPressed: onSearch,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Ad type: '),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: adType,
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All')),
                  DropdownMenuItem(
                    value: 'POLITICAL_AND_ISSUE_ADS',
                    child: Text('Political'),
                  ),
                  DropdownMenuItem(
                    value: 'HOUSING_ADS',
                    child: Text('Housing'),
                  ),
                ],
                onChanged: (v) => onAdTypeChanged(v ?? 'ALL'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdsList extends StatelessWidget {
  const _AdsList({
    required this.ads,
    required this.scrollController,
    required this.isLoadingMore,
  });

  final List<FbAdEntity> ads;
  final ScrollController scrollController;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: ads.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == ads.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _AdTile(ad: ads[i]);
      },
    );
  }
}

class _AdTile extends StatelessWidget {
  const _AdTile({required this.ad, this.trailing});

  final FbAdEntity ad;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.campaign_outlined),
        title: Text(
          ad.pageName ?? ad.pageId ?? ad.id,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          ad.adCreativeBody ?? ad.adCreativeLinkTitle ?? '—',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: trailing,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => AdDetailScreen(ad: ad),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message ?? 'Something went wrong.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


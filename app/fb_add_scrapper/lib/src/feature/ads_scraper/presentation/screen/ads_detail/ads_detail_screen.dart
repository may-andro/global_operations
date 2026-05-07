import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows all details for a single Facebook Ad.
class AdDetailScreen extends StatelessWidget {
  const AdDetailScreen({super.key, required this.ad});

  final FbAdEntity ad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ad.pageName ?? ad.id, overflow: TextOverflow.ellipsis),
        actions: [
          if (ad.adSnapshotUrl != null)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              tooltip: 'Open snapshot',
              onPressed: () => _launchUrl(ad.adSnapshotUrl!),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Page',
            children: [
              _Row('Page name', ad.pageName),
              _Row('Page ID', ad.pageId),
            ],
          ),
          _Section(
            title: 'Creative',
            children: [
              _Row('Body', ad.adCreativeBody),
              _Row('Link title', ad.adCreativeLinkTitle),
              _Row('Link description', ad.adCreativeLinkDescription),
              _Row('Link caption', ad.adCreativeLinkCaption),
              _Row('Destination URL', ad.adCreativeLinkUrl),
            ],
          ),
          _Section(
            title: 'Delivery',
            children: [
              _Row('Created', ad.adCreationTime),
              _Row('Started', ad.adDeliveryStartTime),
              _Row('Stopped', ad.adDeliveryStopTime),
              _Row('Currency', ad.currency),
              _Row('Funding entity', ad.fundingEntity),
              _Row(
                'Impressions',
                _rangeText(ad.impressionsLowerBound, ad.impressionsUpperBound),
              ),
              _Row(
                'Spend',
                _rangeText(ad.spendLowerBound, ad.spendUpperBound),
              ),
            ],
          ),
          _Section(
            title: 'Targeting',
            children: [
              _Row('Platforms', ad.publisherPlatforms?.join(', ')),
              _Row('Languages', ad.languages?.join(', ')),
            ],
          ),
          _Section(
            title: 'Meta',
            children: [
              _Row('Ad Archive ID', ad.id),
              _Row('Scraped at', ad.scrapedAt),
            ],
          ),
          if (ad.adSnapshotUrl != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_browser),
              label: const Text('View Ad Snapshot'),
              onPressed: () => _launchUrl(ad.adSnapshotUrl!),
            ),
          ],
        ],
      ),
    );
  }

  String? _rangeText(int? lower, int? upper) {
    if (lower == null && upper == null) return null;
    return '${lower ?? '?'} – ${upper ?? '?'}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final relevant = children.whereType<_Row>().where((r) => r.value != null);
    if (relevant.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...relevant,
        const Divider(),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: SelectableText(value!)),
        ],
      ),
    );
  }
}


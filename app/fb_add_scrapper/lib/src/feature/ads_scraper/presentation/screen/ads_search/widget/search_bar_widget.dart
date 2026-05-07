import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
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
      padding: EdgeInsets.all(context.space(factor: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DSTextFieldWidget(
                  controller: controller,
                  hintText: 'Search advertiser or keyword…',
                  suffixIcon: Icons.search,
                  onFieldSubmitted: (_) => onSearch(),
                ),
              ),
              SizedBox(width: context.space()),
              FilledButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Scrape'),
                onPressed: onSearch,
              ),
            ],
          ),
          SizedBox(height: context.space()),
          Row(
            children: [
              DSTextWidget(
                'Ad type:',
                style: context.typography.bodyMedium,
                color: context.colorPalette.neutral.grey6,
              ),
              SizedBox(width: context.space()),
              DropdownButton<String>(
                value: adType,
                underline: const SizedBox.shrink(),
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


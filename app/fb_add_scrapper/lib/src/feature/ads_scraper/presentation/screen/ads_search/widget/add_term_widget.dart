import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The input bar at the top — equivalent to FilterSectionWidget.
/// Lets the user type a search term and tap Add to trigger a scrape.
class AddTermWidget extends StatefulWidget {
  const AddTermWidget({super.key});

  @override
  State<AddTermWidget> createState() => _AddTermWidgetState();
}

class _AddTermWidgetState extends State<AddTermWidget> {
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
    context.read<AdsSearchBloc>().add(
          AddSearchTermEvent(searchTerms: term, adType: _adType),
        );
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsSearchBloc, AdsSearchState>(
      buildWhen: (p, c) {
        if (c is! AdsSearchLoadedState) return false;
        final prev = p is AdsSearchLoadedState ? p : null;
        return prev?.isAdding != c.isAdding || prev?.addError != c.addError;
      },
      builder: (context, state) {
        final loaded = state is AdsSearchLoadedState ? state : null;
        final isAdding = loaded?.isAdding ?? false;
        final error = loaded?.addError;

        return DsCardWidget(
          backgroundColor: context.colorPalette.background.primary,
          elevation: context.isDesktop ? null : context.dimen.elevationLevel3,
          radius: context.isDesktop ? null : context.dimen.radiusLevel3,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.space(factor: 2),
              vertical: context.space(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _onAdd(),
                        decoration: InputDecoration(
                          hintText: 'Enter search term...',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.space(factor: 1.5),
                            vertical: context.space(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.space()),
                    AnimatedSwitcher(
                      duration: 200.ms,
                      child: isAdding
                          ? SizedBox(
                              key: const ValueKey('loading'),
                              width: context.space(factor: 5),
                              height: context.space(factor: 5),
                              child: Padding(
                                padding: EdgeInsets.all(context.space()),
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            )
                          : ElevatedButton(
                              key: const ValueKey('add'),
                              onPressed: _onAdd,
                              child: const Text('Add'),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: context.space()),
                DropdownButtonFormField<String>(
                  value: _adType,
                  decoration: InputDecoration(
                    labelText: 'Ad type',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.space(factor: 1.5),
                      vertical: context.space(),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('All')),
                    DropdownMenuItem(
                      value: 'POLITICAL_AND_ISSUE_ADS',
                      child: Text('Political & Issue'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _adType = v);
                  },
                ),
                if (error != null) ...[
                  SizedBox(height: context.space()),
                  Text(
                    error,
                    style: context.typography.bodySmall.copyWith(
                      color: context.colorPalette.semantic.error.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}


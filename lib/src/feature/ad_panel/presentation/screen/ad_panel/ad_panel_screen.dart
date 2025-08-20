import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/exit_warning_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/widget.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class AdPanelScreen extends StatelessWidget {
  const AdPanelScreen({required this.adPanels, super.key});

  final List<AdPanelEntity> adPanels;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          appServiceLocator.get<AdPanelBloc>()
            ..add(LoadAdPanelsEvent(adPanels)),
      child: const _AdPanelScreenContent(),
    );
  }
}

class _AdPanelScreenContent extends StatefulWidget {
  const _AdPanelScreenContent();

  @override
  State<_AdPanelScreenContent> createState() => _AdPanelScreenContentState();
}

class _AdPanelScreenContentState extends State<_AdPanelScreenContent>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<AdPanelBloc>().state;
    if (state is AdPanelsLoadedState && _tabController == null) {
      _tabController = TabController(
        length: state.adPanels.length,
        vsync: this,
      );
    }
  }

  bool _hasUnsavedChanges(AdPanelState state) {
    return switch (state) {
      AdPanelImageCompressionProgressState() ||
      AdPanelImageUploadProgressState() ||
      AdPanelUpdatingPanelsState() => true,
      AdPanelsLoadedState() => state.hasBeenEdited,
      _ => false,
    };
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges(context.watch<AdPanelBloc>().state),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final navigator = Navigator.of(context);
        final canLeave = await ExitWarningWidget.showAsDialogOrBottomSheet(
          context,
        );
        if (canLeave == true && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.colorPalette.background.primary.color,
        appBar: DSAppBarWidget(
          height: DSAppBarWidget.getHeight(context),
          actions: [
            BlocBuilder<AdPanelBloc, AdPanelState>(
              builder: (context, state) {
                final isLoading = switch (state) {
                  AdPanelLoadingState() ||
                  AdPanelImageCompressionProgressState() ||
                  AdPanelImageUploadProgressState() ||
                  AdPanelUpdatingPanelsState() => true,
                  _ => false,
                };

                return IconButton(
                  icon: isLoading
                      ? Padding(
                          padding: EdgeInsets.all(context.space()),
                          child: DSLoadingWidget(
                            size: DSAppBarWidget.getHeight(context),
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  tooltip: context.localizations.adPanelSubmitUpdateTooltip,
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<AdPanelBloc>().add(
                            const UpdateAdPanelsEvent(),
                          );
                        },
                );
              },
            ),
          ],
        ),
        body: ContentWidget(tabController: _tabController),
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/extension/failure_message_extension.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/face_tab_bar_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/face_tab_content_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/flexible_space_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/progress_info_card_widget.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key, required this.tabController});

  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdPanelBloc, AdPanelState>(
      listener: (context, state) {
        switch (state) {
          case AdPanelErrorState():
            context.showSnackBar(
              snackBar: DSSnackBar(
                message: context.localizations.errorUnexpected(state.message),
                type: DSSnackBarType.error,
              ),
            );
          case AdPanelUploadErrorState():
            context.showSnackBar(
              snackBar: DSSnackBar(
                message:
                    state.uploadImageFileFailure?.getMessage(context) ??
                    state.uploadRawImageFailure?.getMessage(context) ??
                    context.localizations.errorUploadUnknown,
                type: DSSnackBarType.error,
              ),
            );
          case AdPanelUpdateErrorState():
            context.showSnackBar(
              snackBar: DSSnackBar(
                message: state.failure.getMessage(context),
                type: DSSnackBarType.error,
              ),
            );
          case AdPanelImageCompressionProgressState():
            ImageCompressionProgressWidget.showAsDialogOrBottomSheet(context);
          case DismissAdPanelImageCompressionProgressState():
            context.pop();
          case AdPanelImageCompressionErrorState():
            ImageCompressionFailureWidget.showAsDialogOrBottomSheet(
              context,
              filePickerFailure: state.filePickerFailure,
              imagePickerFailure: state.imagePickerFailure,
            );
          case AdPanelSuccessState():
            context.showSnackBar(
              snackBar: DSSnackBar(
                message: context.localizations.adPanelUpdateSuccess,
                type: DSSnackBarType.success,
              ),
            );
            context.pop();

          default:
            // Do nothing for other states
            break;
        }
      },
      builder: (context, state) {
        switch (state) {
          case AdPanelLoadingState():
            return ProgressInfoCardWidget(
              title: context.localizations.adPanelUpdatingTitle,
              description: context.localizations.adPanelUpdatingDescription,
            );
          case AdPanelImageUploadProgressState():
            return ProgressInfoCardWidget(
              title: context.localizations.adPanelUploadingImagesTitle,
              description: context.localizations
                  .adPanelUploadingImagesDescription(
                    state.currentFileIndex,
                    state.totalFiles,
                  ),
              progress: state.currentFileIndex / state.totalFiles,
            );
          case AdPanelUpdatingPanelsState():
            return ProgressInfoCardWidget(
              title: context.localizations.adPanelUpdatingPanelsTitle,
              description:
                  context.localizations.adPanelUpdatingPanelsDescription,
            );
          case final AdPanelsLoadedState state:
            if (tabController == null) {
              return const SizedBox.shrink();
            }
            final adPanels = state.adPanels;
            final filesToUpload = state.filesToUpload;
            final rawFilesToUpload = state.rawFilesToUpload;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  backgroundColor:
                      context.colorPalette.background.primary.color,
                  foregroundColor: context.colorPalette.background.primary.color,
                  surfaceTintColor: context.colorPalette.background.primary.color,
                  expandedHeight: FlexibleSpaceWidget.height(context),
                  flexibleSpace: FlexibleSpaceWidget(adPanel: adPanels.first),
                  bottom: FaceTabBarWidget(
                    tabController: tabController!,
                    adPanels: adPanels,
                  ),
                ),
              ],
              body: SafeArea(
                child: TabBarView(
                  controller: tabController,
                  children: adPanels
                      .mapIndexed(
                        (index, adPanel) => FaceTabContentWidget(
                          index: index,
                          adPanel: adPanel,
                          filesToUpload: filesToUpload[adPanel.key] ?? [],
                          rawFilesToUpload: rawFilesToUpload[adPanel.key] ?? [],
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

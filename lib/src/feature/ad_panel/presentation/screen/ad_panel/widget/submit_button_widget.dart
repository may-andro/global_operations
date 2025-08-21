import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key, this.isInAppBar = true});

  final bool isInAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdPanelBloc, AdPanelState>(
      builder: (context, state) {
        final isLoading = switch (state) {
          AdPanelLoadingState() ||
          AdPanelImageCompressionProgressState() ||
          AdPanelImageUploadProgressState() ||
          AdPanelUpdatingPanelsState() => true,
          _ => false,
        };

        final onPressed = isLoading
            ? null
            : () {
                context.read<AdPanelBloc>().add(const UpdateAdPanelsEvent());
              };

        if (isInAppBar) {
          return AnimatedSwitcher(
            duration: 300.milliseconds,
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: !context.isDesktop
                ? DSIconButtonWidget(
                    Icons.check_rounded,
                    iconColor: context.colorPalette.brand.onProminent,
                    buttonColor: context.colorPalette.brand.prominent,
                    onPressed: onPressed,
                    isLoading: isLoading,
                  )
                : const SizedBox.shrink(),
          );
        }

        return AnimatedSwitcher(
          duration: 300.milliseconds,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: context.isDesktop
              ? DSIconButtonWidget(
                  Icons.check_rounded,
                  iconColor: context.colorPalette.brand.onProminent,
                  buttonColor: context.colorPalette.brand.prominent,
                  onPressed: onPressed,
                  isLoading: isLoading,
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

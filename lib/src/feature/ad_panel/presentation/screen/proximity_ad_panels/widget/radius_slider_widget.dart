import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';

class RadiusSliderWidget extends StatelessWidget {
  const RadiusSliderWidget({super.key, required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProximityAdPanelsBloc, ProximityAdPanelsState>(
      builder: (context, state) {
        final radius = _extractRadius(state);

        return Row(
          children: [
            DSIconWidget(
              Icons.radar_rounded,
              size: DSIconSize.medium,
              color: context.colorPalette.background.onPrimary,
            ),
            DSHorizontalSpacerWidget(context.isDesktop ? 0.5 : 0.75),
            Expanded(
              child: Slider(
                min: 1.0,
                max: 20.0,
                divisions: 5,
                value: radius,
                label: '${radius.toStringAsFixed(2)} km',
                activeColor: isEnabled
                    ? context.colorPalette.brand.primary.color
                    : context.colorPalette.background.disabled.color,
                inactiveColor: context.colorPalette.neutral.grey3.color,
                onChanged: isEnabled
                    ? (value) {
                        context.read<ProximityAdPanelsBloc>().add(
                          UpdateSearchRadiusEvent(value),
                        );
                      }
                    : null,
              ),
            ),
            DSTextWidget(
              context.localizations.adPanelSearchRadiusLabel(
                radius.toStringAsFixed(2),
              ),
              style: context.typography.bodyMedium,
              color: context.colorPalette.background.onPrimary,
            ),
          ],
        );
      },
    );
  }

  /// Extracts radius value from the current state
  double _extractRadius(ProximityAdPanelsState state) {
    switch (state) {
      case AdPanelsLoadedState():
        return state.radiusInKm;
      case AdPanelsListLoadingState():
        return state.previousState.radiusInKm;
      default:
        return 5.0;
    }
  }
}

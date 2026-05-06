import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/location/domain/domain.dart';
import 'package:global_ops/src/feature/location/presentation/location_listener/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class LocationListenerWidget extends StatelessWidget {
  const LocationListenerWidget({
    super.key,
    required this.builder,
    this.loadingWidget,
    this.autoStart = true,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
  });

  final Widget Function(BuildContext context, LocationEntity location) builder;
  final Widget? loadingWidget;
  final bool autoStart;
  final Duration timeout;
  final int maxRetries;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = appServiceLocator.get<LocationListenerBloc>();
        if (autoStart) {
          bloc.add(
            StartTrackingLocationEvent(
              timeout: timeout,
              maxRetries: maxRetries,
            ),
          );
        }
        return bloc;
      },
      child: BlocBuilder<LocationListenerBloc, LocationListenerState>(
        builder: (context, state) {
          switch (state) {
            case final LocationListenerInitialState _:
              return loadingWidget ?? const _LocationLoadingWidget();
            case final LocationListenerLoadingState _:
              return loadingWidget ?? const _LocationLoadingWidget();
            case final LocationListenerLoadedState state:
              return builder(context, state.location);
            case final LocationListenerFailureState state:
              return _LocationFailureWidget(
                error: state.error,
                errorType: state.errorType,
              );
            default:
              return loadingWidget ?? const _LocationLoadingWidget();
          }
        },
      ),
    );
  }
}

class _LocationLoadingWidget extends StatelessWidget {
  const _LocationLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(child: DSLoadingWidget(size: context.space(factor: 5)));
  }
}

class _LocationFailureWidget extends StatelessWidget {
  const _LocationFailureWidget({required this.error, this.errorType});

  final Object error;
  final LocationErrorType? errorType;

  @override
  Widget build(BuildContext context) {
    final (message, showRetry, icon) = _getErrorDetails(
      error.toString(),
      errorType,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: context.space(factor: 6),
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: context.space(factor: 2)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          if (showRetry) ...[
            SizedBox(height: context.space(factor: 3)),
            ElevatedButton(
              onPressed: () {
                context.read<LocationListenerBloc>().add(
                  const StartTrackingLocationEvent(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  (String, bool, IconData) _getErrorDetails(
    String errorMessage,
    LocationErrorType? errorType,
  ) {
    switch (errorType) {
      case LocationErrorType.permissionDenied:
        return (
          'Location permission is required to use this feature. Please enable location access in your device settings.',
          false,
          Icons.location_disabled,
        );
      case LocationErrorType.serviceDisabled:
        return (
          'Location services are disabled. Please enable location services in your device settings.',
          false,
          Icons.location_off,
        );
      case LocationErrorType.networkError:
        return (
          'Unable to get your location. Please check your internet connection and try again.',
          true,
          Icons.signal_wifi_off,
        );
      case LocationErrorType.timeout:
        return (
          'Location request timed out. Please try again.',
          true,
          Icons.access_time,
        );
      case LocationErrorType.unknown:
      case null:
        return (
          'Unable to get your location. Please try again.',
          true,
          Icons.location_off,
        );
    }
  }
}

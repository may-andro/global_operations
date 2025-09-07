import 'package:equatable/equatable.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitialState extends SettingState {
  const SettingInitialState();
}

class SettingLoadingState extends SettingState {
  const SettingLoadingState();
}

class SettingLoadedState extends SettingState {
  const SettingLoadedState({
    required this.isLocationEnabled,
    required this.locationBasedSearch,
  });

  SettingLoadedState copyWith({
    bool? isLocationEnabled,
    bool? locationBasedSearch,
  }) {
    return SettingLoadedState(
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      locationBasedSearch: locationBasedSearch ?? this.locationBasedSearch,
    );
  }

  final bool isLocationEnabled;
  final bool locationBasedSearch;

  @override
  List<Object?> get props => [isLocationEnabled, locationBasedSearch];
}

class SettingErrorState extends SettingState {
  const SettingErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

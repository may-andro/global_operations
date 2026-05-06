import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({
    this.selectedIndex = 0,
    this.logoClickCount = 0,
    this.isDeveloperModeEnabled = false,
  });

  final int selectedIndex;
  final int logoClickCount;
  final bool isDeveloperModeEnabled;

  HomeState copyWith({
    int? selectedIndex,
    int? logoClickCount,
    bool? isDeveloperModeEnabled,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      logoClickCount: logoClickCount ?? this.logoClickCount,
      isDeveloperModeEnabled:
          isDeveloperModeEnabled ?? this.isDeveloperModeEnabled,
    );
  }

  @override
  List<Object> get props => [
    selectedIndex,
    logoClickCount,
    isDeveloperModeEnabled,
  ];
}

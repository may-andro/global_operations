import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({required this.selectedIndex});

  final int selectedIndex;

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [selectedIndex];
}

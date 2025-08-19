import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class TabChangedEvent extends HomeEvent {
  const TabChangedEvent(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

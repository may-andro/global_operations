import 'package:equatable/equatable.dart';

sealed class AdPanelsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAdPanelsEvent extends AdPanelsEvent {}

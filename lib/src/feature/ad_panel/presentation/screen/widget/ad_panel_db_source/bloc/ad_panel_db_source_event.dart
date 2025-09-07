import 'package:equatable/equatable.dart';

sealed class AdPanelDbSourceEvent extends Equatable {
  const AdPanelDbSourceEvent();

  @override
  List<Object?> get props => [];
}

class LoadDbSourcesEvent extends AdPanelDbSourceEvent {
  const LoadDbSourcesEvent();
}

class SelectDbSourceEvent extends AdPanelDbSourceEvent {
  const SelectDbSourceEvent(this.source);

  final String source;

  @override
  List<Object?> get props => [source];
}

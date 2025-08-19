import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/home_event.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(selectedIndex: 0)) {
    on<TabChangedEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}

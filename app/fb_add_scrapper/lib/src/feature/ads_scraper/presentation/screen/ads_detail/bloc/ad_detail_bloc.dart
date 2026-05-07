import 'dart:async';

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

abstract class AdDetailEvent {
  const AdDetailEvent();
}

class LoadPageInfoEvent extends AdDetailEvent {
  const LoadPageInfoEvent(this.pageId);
  final String pageId;
}

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

enum AdDetailPageInfoStatus { idle, loading, success, failure }

class AdDetailState {
  const AdDetailState({
    this.status = AdDetailPageInfoStatus.idle,
    this.pageInfo,
    this.errorMessage,
  });

  final AdDetailPageInfoStatus status;
  final FbPageInfoEntity? pageInfo;
  final String? errorMessage;

  AdDetailState copyWith({
    AdDetailPageInfoStatus? status,
    FbPageInfoEntity? pageInfo,
    String? errorMessage,
  }) {
    return AdDetailState(
      status: status ?? this.status,
      pageInfo: pageInfo ?? this.pageInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ---------------------------------------------------------------------------
// BLoC
// ---------------------------------------------------------------------------

class AdDetailBloc extends Bloc<AdDetailEvent, AdDetailState> {
  AdDetailBloc({
    required this.getPageInfoUseCase,
    required this.accessToken,
  }) : super(const AdDetailState()) {
    on<LoadPageInfoEvent>(_onLoadPageInfo);
  }

  final GetPageInfoUseCase getPageInfoUseCase;
  final String accessToken;

  FutureOr<void> _onLoadPageInfo(
    LoadPageInfoEvent event,
    Emitter<AdDetailState> emit,
  ) async {
    emit(state.copyWith(status: AdDetailPageInfoStatus.loading));

    final result = await getPageInfoUseCase(
      GetPageInfoInput(accessToken: accessToken, pageId: event.pageId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdDetailPageInfoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (pageInfo) => emit(
        state.copyWith(
          status: AdDetailPageInfoStatus.success,
          pageInfo: pageInfo,
        ),
      ),
    );
  }
}


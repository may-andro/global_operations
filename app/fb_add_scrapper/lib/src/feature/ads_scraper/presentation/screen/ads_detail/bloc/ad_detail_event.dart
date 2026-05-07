abstract class AdDetailEvent {
  const AdDetailEvent();
}

class LoadPageInfoEvent extends AdDetailEvent {
  const LoadPageInfoEvent(this.pageId);

  final String pageId;
}


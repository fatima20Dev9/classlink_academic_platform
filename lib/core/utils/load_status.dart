// Unified async UI status used by all Getx controllers and AsyncView.

enum LoadStatus { idle, loading, success, empty, error }

extension LoadStatusX on LoadStatus {
  bool get isIdle => this == LoadStatus.idle;
  bool get isLoading => this == LoadStatus.loading;
  bool get isSuccess => this == LoadStatus.success;
  bool get isEmpty => this == LoadStatus.empty;
  bool get isError => this == LoadStatus.error;
}

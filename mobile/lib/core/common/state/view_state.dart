enum ViewState {
  initial,
  loading,
  loadingNext,
  error,
  success;
}

extension ViewStateExtension on ViewState {
  bool get isLoading => this == ViewState.loading;

  bool get isNotLoading => this != ViewState.loading;

  bool get isLoadingNext => this == ViewState.loadingNext;

  bool get isInitial => this == ViewState.initial;

  bool get isError => this == ViewState.error;

  bool get isSuccess => this == ViewState.success;
}

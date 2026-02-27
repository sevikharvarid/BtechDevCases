import 'package:flutter/material.dart';
import 'package:mobile/core/common/state/view_state.dart';
import 'package:equatable/equatable.dart';


class ViewData<T> extends Equatable {
  final ViewState status;
  final T? data;
  final String? message;

  const ViewData._({required this.status, this.data, this.message});

  factory ViewData.initial({T? data}) =>
      ViewData._(status: ViewState.initial, data: data);

  factory ViewData.loading({String? message}) =>
      ViewData._(status: ViewState.loading, message: message);

  factory ViewData.loadingNext({T? data, String? message}) =>
      ViewData._(status: ViewState.loadingNext, data: data, message: message);

  factory ViewData.success({T? data, String? message}) =>
      ViewData._(status: ViewState.success, data: data, message: message);

  factory ViewData.error({T? data, String? message}) =>
      ViewData._(status: ViewState.error, data: data, message: message);

  bool get hasData => data != null;

  bool get isEmptyList =>
      data == null || data is List && (data as List).isEmpty;

  bool get isNotEmptyList => data is List && (data as List).isNotEmpty;

  Widget when({
    Widget Function()? initial,
    Widget Function()? loading,
    Widget Function()? loadingNext,
    Widget Function(String? message)? error,
    Widget Function(T data)? success,
    Widget Function(ViewState status, T? data, String? message)? orElse,
  }) {
    switch (status) {
      case ViewState.initial:
        return initial?.call() ??
            orElse?.call(status, data, message) ??
            const SizedBox.shrink();
      case ViewState.loading:
        return loading?.call() ??
            orElse?.call(status, data, message) ??
            const SizedBox.shrink();
      case ViewState.loadingNext:
        return loadingNext?.call() ??
            orElse?.call(status, data, message) ??
            const SizedBox.shrink();
      case ViewState.error:
        return error?.call(message) ??
            orElse?.call(status, data, message) ??
            Text(message ?? 'Terjadi kesalahan');
      case ViewState.success:
        final d = data;
        if (d != null) {
          return success?.call(d as T) ??
              orElse?.call(status, data, message) ??
              const SizedBox.shrink();
        } else {
          return error?.call('Data tidak tersedia') ??
              orElse?.call(status, data, message) ??
              const Text('Data tidak tersedia');
        }
    }
  }

  ViewData<T> copyWith({ViewState? status, T? data, String? message}) {
    return ViewData._(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, data, message];

  @override
  String toString() =>
      'ViewData<$T>(status: $status, message: $message, data: $data)';
}

extension ViewDataListenerExtension<T> on ViewData<T> {
  void listen({
    void Function()? loading,
    void Function(String? message)? error,
    void Function(T data)? success,
    void Function()? initial,
    void Function()? loadingNext,
  }) {
    switch (status) {
      case ViewState.initial:
        initial?.call();
        break;
      case ViewState.loading:
        loading?.call();
        break;
      case ViewState.loadingNext:
        loadingNext?.call();
        break;
      case ViewState.error:
        error?.call(message);
        break;
      case ViewState.success:
        success?.call(data as T);
        break;
    }
  }
}

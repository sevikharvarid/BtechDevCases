import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/state/view_data.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState, EquatableMixin {
  const AuthState._();

  const factory AuthState({required ViewData<AuthUser> authStatus}) =
      _AuthState;

  factory AuthState.initial() =>
      AuthState(authStatus: ViewData.initial());

  @override
  List<Object?> get props => [authStatus];
}

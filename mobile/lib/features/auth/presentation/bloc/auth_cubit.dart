import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/common/state/view_data.dart';
import '../../domain/entities/auth_user.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial()) {
    _loadSavedAuth();
  }

  final _storage = const FlutterSecureStorage();
  final _dio = dio; 

  Future<void> _loadSavedAuth() async {
    emit(state.copyWith(authStatus: ViewData.loading()));
    final token = await _storage.read(key: 'jwt_token');
    final email = await _storage.read(key: 'user_email');

    if (token != null && email != null) {
      emit(state.copyWith(
        authStatus: ViewData.success(data: AuthUser(email: email, userId: null)),
      ));
    } else {
      emit(state.copyWith(authStatus: ViewData.initial()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(state.copyWith(authStatus: ViewData.loading()));
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      });

      final token = response.data['token'] as String?;
      final message = response.data['message'] as String?;

      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
        await _storage.write(key: 'user_email', value: email);
        emit(state.copyWith(
          authStatus: ViewData.success(data: AuthUser(email: email, userId: null)),
        ));
      } else {
        emit(state.copyWith(authStatus: ViewData.error(message: message ?? 'Register gagal')));
      }
    } on DioException catch (e) {
      emit(state.copyWith(authStatus: ViewData.error(message: e.response?.data['error'] ?? 'Error jaringan')));
    } catch (e) {
      emit(state.copyWith(authStatus: ViewData.error(message: e.toString())));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(authStatus: ViewData.loading()));
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'] as String?;
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
        await _storage.write(key: 'user_email', value: email);
        emit(state.copyWith(
          authStatus: ViewData.success(data: AuthUser(email: email, userId: null)),
        ));
      } else {
        emit(state.copyWith(authStatus: ViewData.error(message: 'Login gagal')));
      }
    } on DioException catch (e) {
      emit(state.copyWith(authStatus: ViewData.error(message: e.response?.data['error'] ?? 'Error')));
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    emit(AuthState.initial());
  }
}
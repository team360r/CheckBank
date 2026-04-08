import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String? error;
  const AuthState({this.isLoggedIn = false, this.error});

  AuthState copyWith({bool? isLoggedIn, String? error}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void login(String email, String password) {
    if (email == 'alex@checkbank.dev' && password == 'password') {
      state = const AuthState(isLoggedIn: true);
    } else {
      state = const AuthState(error: 'Invalid email or password');
    }
  }

  void logout() {
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

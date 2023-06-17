import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout(errorMessage: 'Credenciales incorrectas');
    } on ConnectionTimeout {
      logout(errorMessage: 'Tiempo de espera agotado');
    } on CustomError catch (e) {
      logout(errorMessage: e.message);
    } catch (e) {
      logout(errorMessage: 'Error desconocido');
    }
  }

  Future<void> registerUser(
      String email, String password, String fullName) async {}

  Future<void> checkAuthStatus(String token) async {}

  Future<void> _setLoggedUser(User user) async {
    // TODO: Guardar el usuario en el storage
    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }

  Future<void> logout({String? errorMessage = ''}) async {
    //TODO: Limpiar token del storage
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

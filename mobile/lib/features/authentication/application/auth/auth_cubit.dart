import 'package:bloc/bloc.dart';
import 'package:mobile/features/authentication/domain/user/user.dart';
import 'package:mobile/features/authentication/domain/auth/auth_failure.dart';
import 'package:mobile/features/authentication/infrastructure/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepository) : super(AuthState(status: AuthStatus.initial));

  final AuthRepository authRepository;

  Future<void> signIn(String email, String password) async {
    emit(AuthState(status: AuthStatus.loading));
    final response = await authRepository.signInWithEmailAndPassword(email: email, password: password);
    response.fold((l) {
      return emit(AuthState(status: AuthStatus.failure, authFailure: l));
    }, (r) async {
      return emit(AuthState(status: AuthStatus.success, user: r));
    });
  }
}

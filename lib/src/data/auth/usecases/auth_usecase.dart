import 'package:careflow_app/src/data/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // Caso de uso para login
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _authRepository.loginWithEmailAndPassword(email, password);
    } catch (e) {
      throw Exception("Erro no login: ${e.toString()}");
    }
  }

  // Caso de uso para cadastro de Paciente
  Future<User?> signUpPaciente({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await _authRepository.registerPaciente(email, password, name);
    } catch (e) {
      throw Exception("Erro no cadastro de paciente: ${e.toString()}");
    }
  }

  // Caso de uso para cadastro de Profissional
  Future<User?> signUpProfissional({
    required String email,
    required String password,
    required String name,
    required String especialidade,
    required String numRegistro,
  }) async {
    try {
      return await _authRepository.registerProfissional(
        email,
        password,
        name,
        especialidade,
        numRegistro,
      );
    } catch (e) {
      throw Exception("Erro no cadastro de profissional: ${e.toString()}");
    }
  }

  // Caso de uso para logout
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      throw Exception("Erro ao sair: ${e.toString()}");
    }
  }
}

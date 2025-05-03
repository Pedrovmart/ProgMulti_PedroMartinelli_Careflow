import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:careflow_app/app/core/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  firebase_auth.User? _user;
  String _userType = '';

  firebase_auth.User? get user => _user;
  String get userType => _userType;

  bool get isAuthenticated => _user != null;

  Stream<firebase_auth.User?> get authStateChanges =>
      _authRepository.authStateChanges;

  Future<void> login(String email, String password) async {
    try {
      _user = await _authRepository.loginWithEmailAndPassword(email, password);
      _userType = await _authRepository.getUserType(_user!.uid);
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao fazer login: ${e.toString()}");
    }
  }

  Future<void> registerPaciente(
    String email,
    String password,
    String name,
  ) async {
    try {
      _user = await _authRepository.registerPaciente(email, password, name);
      _userType = 'paciente';
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao registrar paciente: ${e.toString()}");
    }
  }

  Future<void> registerProfissional(
    String email,
    String password,
    String name,
    String especialidade,
  ) async {
    try {
      _user = await _authRepository.registerProfissional(
        email,
        password,
        name,
        especialidade,
      );
      _userType = 'profissional';
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao registrar profissional: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    _userType = '';
    notifyListeners();
  }
}

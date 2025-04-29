import 'dart:developer';

import 'package:careflow_app/src/data/auth/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCase _authUseCase;

  AuthProvider(this._authUseCase);

  User? _user;
  User? get user => _user;

  bool get isAuthenticated => _user != null;

  String _userType = '';
  String get userType => _userType;

  Stream<User?> get authStateChanges => _authUseCase.authStateChanges();

  Future<void> setUserType() async {
    if (_user != null) {
      _userType = await _authUseCase.getUserType(_user!.uid);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _user = await _authUseCase.signIn(email: email, password: password);

      if (_user != null) {
        await setUserType();
      }
      notifyListeners();
    } catch (e) {
      _user = null;
      _userType = '';
      notifyListeners();
      log("Erro no login: $e");
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String userType,
    String? especialidade,
    String? numRegistro,
    String? idEmpresa,
  }) async {
    try {
      if (userType == 'paciente') {
        _user = await _authUseCase.signUpPaciente(
          email: email,
          password: password,
          name: name,
        );
      } else {
        _user = await _authUseCase.signUpProfissional(
          email: email,
          password: password,
          name: name,
          especialidade: especialidade!,
          numRegistro: numRegistro!,
        );
      }

      _userType = userType;
      notifyListeners();
    } catch (e) {
      _user = null;
      _userType = '';
      notifyListeners();
      log("Erro no cadastro: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _authUseCase.signOut();
      _user = null;
      _userType = '';
      notifyListeners();
    } catch (e) {
      log("Erro ao sair: $e");
    }
  }
}

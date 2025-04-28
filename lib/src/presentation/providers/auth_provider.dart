import 'dart:developer';

import 'package:careflow_app/src/data/auth/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCase authUseCase;

  AuthProvider(this.authUseCase);

  User? _user;
  User? get user => _user;

  bool get isAuthenticated => _user != null;

  String _userType =
      ''; // Variável para armazenar o tipo de usuário (paciente ou profissional)
  String get userType => _userType;

  // Método para login
  Future<void> login(String email, String password) async {
    try {
      _user = await authUseCase.signIn(email: email, password: password);
      notifyListeners();
    } catch (e) {
      _user = null;
      _userType = '';
      notifyListeners();
      log("Erro no login: $e");
    }
  }

  // Método para cadastro de Paciente ou Profissional
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
        _user = await authUseCase.signUpPaciente(
          email: email,
          password: password,
          name: name,
        );
      } else {
        _user = await authUseCase.signUpProfissional(
          email: email,
          password: password,
          name: name,
          especialidade: especialidade!,
          numRegistro: numRegistro!,
        );
      }

      _userType = userType; // Define o tipo de usuário no AuthProvider
      notifyListeners();
    } catch (e) {
      _user = null;
      _userType = '';
      notifyListeners();
      log("Erro no cadastro: $e");
    }
  }

  // Método para logout
  Future<void> signOut() async {
    try {
      await authUseCase.signOut();
      _user = null;
      _userType = '';
      notifyListeners();
    } catch (e) {
      log("Erro ao sair: $e");
    }
  }
}

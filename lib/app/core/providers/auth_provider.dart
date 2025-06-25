import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:careflow_app/app/core/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  firebase_auth.User? _currentUser;
  String _userType = '';
  bool _initialized = false;

  firebase_auth.User? get currentUser => _currentUser;
  String get userType => _userType;

  bool get isAuthenticated => _currentUser != null;
  bool get initialized => _initialized;

  Stream<firebase_auth.User?> get authStateChanges =>
      _authRepository.authStateChanges;
      
  AuthProvider() {
    _initializeAuth();
  }
  
  Future<void> _initializeAuth() async {
    try {
      _currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      
      if (_currentUser != null) {
        _userType = await _authRepository.getUserType(_currentUser!.uid);
      }
      
      firebase_auth.FirebaseAuth.instance.authStateChanges().listen((user) {
        _currentUser = user;
        if (user == null) {
          _userType = '';
        }
        notifyListeners();
      });
      
      _initialized = true;
      notifyListeners();
    } catch (e) {
      log('Erro ao inicializar autenticação: $e');
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    log('AuthProvider: Iniciando login para email: $email');
    try {
      log('AuthProvider: Tentando _authRepository.loginWithEmailAndPassword...');
      _currentUser = await _authRepository.loginWithEmailAndPassword(
        email,
        password,
      );
      log('AuthProvider: Login no Firebase Auth bem-sucedido. UID: ${_currentUser?.uid}');
      
      if (_currentUser != null) {
        log('AuthProvider: Tentando _authRepository.getUserType para UID: ${_currentUser!.uid}');
        _userType = await _authRepository.getUserType(_currentUser!.uid);
        log('AuthProvider: getUserType concluído. UserType: $_userType');
      } else {
        log('AuthProvider: _currentUser é nulo após login bem-sucedido no Firebase Auth. Isso é inesperado.');
        throw Exception('Usuário nulo após autenticação bem-sucedida.');
      }
      notifyListeners();
    } catch (e) {
      log('AuthProvider: Erro durante o login: ${e.toString()}');
      throw Exception("Erro ao fazer login: ${e.toString()}");
    }
  }

  Future<void> registerPaciente(
    String email,
    String password,
    String name,
  ) async {
    try {
      _currentUser = await _authRepository.registerPaciente(
        email,
        password,
        name,
      );
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
    String numRegistro,
  ) async {
    try {
      _currentUser = await _authRepository.registerProfissional(
        email,
        password,
        name,
        especialidade,
        numRegistro,
      );
      _userType = 'profissional';
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao registrar profissional: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _currentUser = null;
    _userType = '';
    notifyListeners();
  }
}

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
      // Obter usuário atual do Firebase
      _currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      
      if (_currentUser != null) {
        // Carregar o tipo de usuário
        _userType = await _authRepository.getUserType(_currentUser!.uid);
      }
      
      // Configurar listener para mudanças de autenticação
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
    try {
      _currentUser = await _authRepository.loginWithEmailAndPassword(
        email,
        password,
      );
      _userType = await _authRepository.getUserType(_currentUser!.uid);
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
  ) async {
    try {
      _currentUser = await _authRepository.registerProfissional(
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
    _currentUser = null;
    _userType = '';
    notifyListeners();
  }
}

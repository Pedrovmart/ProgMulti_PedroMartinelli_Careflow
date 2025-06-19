import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:go_router/go_router.dart';

class SignupController extends ChangeNotifier {
  final AuthProvider _authProvider;
  final ProfissionalProvider _profissionalProvider;

  SignupController(this._authProvider, this._profissionalProvider) {
    _profissionalProvider.addListener(_onProfissionalProviderChanged);
  }
  
  void _onProfissionalProviderChanged() {
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numRegistroController = TextEditingController();
  
  String? _selectedEspecialidade;
  String? get selectedEspecialidade => _selectedEspecialidade;
  List<String> get especialidades => _profissionalProvider.especialidades;
  bool get isLoadingEspecialidades => _profissionalProvider.isLoadingEspecialidades;
  String? get especialidadesError => _profissionalProvider.especialidadesError;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProfissional = false;
  bool get isProfissional => _isProfissional;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setIsProfissional(bool value) {
    _isProfissional = value;
    if (value) {
      fetchEspecialidades();
    }
    notifyListeners();
  }
  
  void setSelectedEspecialidade(String? especialidade) {
    _selectedEspecialidade = especialidade;
    notifyListeners();
  }
  
  Future<void> fetchEspecialidades() async {
    try {
      await _profissionalProvider.fetchEspecialidades();
    } catch (e) {
      log('Erro ao buscar especialidades: $e');
    }
  }
  
  Future<void> init() async {
  }

  Future<String?> registerUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _errorMessage = 'Por favor, preencha nome, email e senha.';
      notifyListeners();
      return null;
    }

    if (_isProfissional) {
      if (numRegistroController.text.isEmpty) {
        _errorMessage = 'Para profissional, preencha o número de registro.';
        notifyListeners();
        return null;
      }
      
      if (_selectedEspecialidade == null) {
        _errorMessage = 'Selecione uma especialidade.';
        notifyListeners();
        return null;
      }
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? navigationRoute;
    try {
      if (_isProfissional) {
        await _authProvider.registerProfissional(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
          _selectedEspecialidade ?? '',
          numRegistroController.text.trim(), 
        );
        if (_authProvider.isAuthenticated) {
          navigationRoute = '/home-profissional';
        }
      } else {
        await _authProvider.registerPaciente(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
        );
        if (_authProvider.isAuthenticated) {
          navigationRoute = '/home-paciente';
        }
      }

      if (navigationRoute == null && _authProvider.isAuthenticated == false) {
        _errorMessage = 'Falha no cadastro. Tente novamente.';
      }

    } catch (e) {
      if (e is Exception) {
        String exceptionMessage = e.toString();
        if (exceptionMessage.startsWith("Exception: ")) {
          exceptionMessage = exceptionMessage.substring("Exception: ".length);
        }
        _errorMessage = exceptionMessage;
      } else {
        _errorMessage = 'Ocorreu um erro desconhecido durante o cadastro.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return navigationRoute;
  }

  void goToLoginPage(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login'); 
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    numRegistroController.dispose();
    _profissionalProvider.removeListener(_onProfissionalProviderChanged);
    super.dispose();
  }
}
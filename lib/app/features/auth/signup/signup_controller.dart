import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SignupController extends ChangeNotifier {
  final AuthProvider _authProvider;

  SignupController(this._authProvider);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController especialidadeController = TextEditingController();
  final TextEditingController numRegistroController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProfissional = false;
  bool get isProfissional => _isProfissional;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setIsProfissional(bool value) {
    _isProfissional = value;
    notifyListeners();
  }

  Future<String?> registerUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _errorMessage = 'Por favor, preencha nome, email e senha.';
      notifyListeners();
      return null;
    }

    if (_isProfissional &&
        (especialidadeController.text.isEmpty || numRegistroController.text.isEmpty)) { 
      _errorMessage = 'Para profissional, preencha especialidade e número de registro.';
      notifyListeners();
      return null;
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
          especialidadeController.text.trim(),
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
      // TODO: Adicionar logging do erro para depuração
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
    especialidadeController.dispose();
    numRegistroController.dispose(); 
    super.dispose();
  }
}
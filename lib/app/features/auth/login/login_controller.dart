import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginController extends ChangeNotifier {
  final AuthProvider _authProvider;

  LoginController(this._authProvider);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> loginUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Por favor, preencha o email e a senha.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    bool loginSuccess = false;
    try {
      await _authProvider.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (_authProvider.isAuthenticated && _authProvider.userType.isNotEmpty) {
        loginSuccess = true;
      } else if (_authProvider.isAuthenticated && _authProvider.userType.isEmpty) {
        _errorMessage = 'Não foi possível determinar o tipo de usuário. Verifique os dados cadastrais.';
        loginSuccess = false;
      } else {
        _errorMessage = 'Falha no login. Verifique suas credenciais.';
        loginSuccess = false;
      }
    } catch (e) {
      loginSuccess = false;
      if (e is Exception) {
        String exceptionMessage = e.toString();
        if (exceptionMessage.startsWith("Exception: ")) {
          exceptionMessage = exceptionMessage.substring("Exception: ".length);
        }
        _errorMessage = exceptionMessage;
      } else {
        _errorMessage = 'Ocorreu um erro desconhecido ao tentar fazer login.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return loginSuccess;
  }

  void goToSignupPage(BuildContext context) {
    context.push('/signup');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
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


      loginSuccess = true;

    } catch (e) {
      if (e is Exception) {
        String exceptionMessage = e.toString();
        if (exceptionMessage.startsWith("Exception: ")) {
          exceptionMessage = exceptionMessage.substring("Exception: ".length);
        }
        _errorMessage = exceptionMessage;
      } else {
        _errorMessage = 'Ocorreu um erro desconhecido ao tentar fazer login.';
      }
      // TODO: Adicionar loging do erro para depuração
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
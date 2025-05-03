// lib/app/routes/routes.dart
import 'package:flutter/material.dart';
import 'package:careflow_app/app/features/auth/login/login_page.dart';
import 'package:careflow_app/app/features/auth/signup/signup_page.dart';
import 'package:careflow_app/app/features/paciente/paciente_main_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_main_page.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homePaciente = '/homePaciente';
  static const String homeProfissional = '/homeProfissional';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case homePaciente:
        return MaterialPageRoute(builder: (_) => PacienteMainPage());
      case homeProfissional:
        return MaterialPageRoute(builder: (_) => ProfissionalMainPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}

import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/features/paciente/paciente_home_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/features/auth/login/login_page.dart';
import 'package:careflow_app/app/features/auth/signup/signup_page.dart';
import 'package:careflow_app/app/features/paciente/paciente_main_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_main_page.dart';

sealed class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homePaciente = '/paciente/home';
  static const String homeProfissional = '/profissional/home';

  static GoRouter createRouter({
    String? initialLocation,
    required AuthProvider authProvider,
  }) {
    return GoRouter(
      initialLocation: initialLocation ?? '/login',
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            final user = authProvider.currentUser;
            if (user == null) {
              return LoginPage();
            } else if (authProvider.userType == 'paciente') {
              return PacienteMainPage(state: state, child: PacienteHomePage());
            } else if (authProvider.userType == 'profissional') {
              return ProfissionalMainPage(
                state: state,
                child: ProfissionalHomePage(),
              );
            }
            return LoginPage();
          },
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => SignUpPage(),
        ),
        ShellRoute(
          builder:
              (context, state, child) =>
                  PacienteMainPage(state: state, child: child),
          routes: [
            GoRoute(
              path: '/paciente/home',
              name: 'homePaciente',
              builder: (context, state) => PacienteHomePage(),
            ),
          ],
        ),
        ShellRoute(
          builder:
              (context, state, child) =>
                  ProfissionalMainPage(state: state, child: child),
          routes: [
            GoRoute(
              path: '/profissional/home',
              name: 'homeProfissional',
              builder: (context, state) => ProfissionalHomePage(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final user = authProvider.currentUser;

        if (user == null &&
            state.uri.toString() != '/login' &&
            state.uri.toString() != '/signup') {
          return '/';
        }

        if (user != null) {
          if (authProvider.userType == 'paciente' &&
              state.uri.toString() == '/login') {
            return '/paciente/home';
          } else if (authProvider.userType == 'profissional' &&
              state.uri.toString() == '/login') {
            return '/profissional/home';
          }
        }

        return null;
      },
      errorBuilder: (context, state) => LoginPage(),
    );
  }
}

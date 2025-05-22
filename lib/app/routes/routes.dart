import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/features/paciente/paciente_home_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_home_page.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/features/auth/login/login_page.dart';
import 'package:careflow_app/app/features/auth/signup/signup_page.dart';
import 'package:careflow_app/app/features/paciente/paciente_main_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_main_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_search_page.dart'; 
import 'package:careflow_app/app/features/profissional/profissional_perfil_publico_page.dart'; 
import 'package:careflow_app/app/features/consultas/calendario_page.dart'; 
import 'package:careflow_app/app/features/paciente/paciente_perfil_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_agendamentos_page.dart';

sealed class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homePaciente = '/paciente/home';
  static const String homeProfissional = '/profissional/home';
  static const String perfilPublicoProfissional =
      '/paciente/busca/perfilProfissional'; 
  static const String calendario =
      '/paciente/calendario'; 
  static const String perfilPaciente =
      '/paciente/perfil';
  static const String profissionalAgendamentos = '/profissional/agendamentos';

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
            GoRoute(
              path: '/paciente/busca',
              name: 'pacienteBusca',
              builder: (context, state) => ProfissionalSearchPage(),
            ),
            GoRoute(
              path:
                  '/paciente/busca/perfilProfissional', 
              name: 'perfilPublicoProfissional',
              builder: (context, state) {
                final profissional = state.extra as Profissional?;
                return ProfissionalPerfilPublicoPage(
                  key: ValueKey(profissional?.id),
                );
              },
            ),
            GoRoute(
              path: '/paciente/calendario',
              name: 'calendario',
              builder: (context, state) => const CalendarioPage(),
            ),
            GoRoute(
              path: '/paciente/perfil',
              name: 'perfilPaciente',
              builder: (context, state) => const PacientePerfilPage(),
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
            GoRoute(
              path: '/profissional/agendamentos',
              name: 'profissionalAgendamentos',
              builder: (context, state) => const ProfissionalAgendamentosPage(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        // Aguardar a inicialização da autenticação
        if (!authProvider.initialized) {
          return null; // Não redirecionar enquanto estiver inicializando
        }
        
        final user = authProvider.currentUser;
        final location = state.uri.toString();

        // Se o usuário não estiver autenticado e tentar acessar uma rota protegida
        if (user == null &&
            location != '/login' &&
            location != '/signup') {
          return '/login';  // Redirecionar para login, não para a raiz
        }

        // Se o usuário estiver autenticado e tentar acessar login
        if (user != null && location == '/login') {
          if (authProvider.userType == 'paciente') {
            return '/paciente/home';
          } else if (authProvider.userType == 'profissional') {
            return '/profissional/home';
          }
        }

        return null; // Sem redirecionamento
      },
      errorBuilder: (context, state) => LoginPage(),
    );
  }
}

import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/features/consultas/pacientes_agendamentos_page.dart';
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
import 'package:careflow_app/app/features/perfil/perfil_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_agendamentos_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_roadmap_page.dart'; // Added import

sealed class Routes {
  // Constants for route names can be kept if they are used for named navigation,
  // but the path strings themselves will now come from the page files.
  // It's also an option to remove these string constants if paths are always sourced from pages.
  // For now, I'll leave them as they might be used for `name:` parameter in GoRoute.

  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String homePacienteName = 'homePaciente';
  static const String pacienteBuscaName = 'pacienteBusca';
  static const String perfilPublicoProfissionalName = 'perfilPublicoProfissional';
  static const String calendarioName = 'calendario';
  static const String perfilPacienteName = 'perfilPaciente';
  static const String homeProfissionalName = 'homeProfissional';
  static const String profissionalAgendamentosName = 'profissionalAgendamentos';
  static const String profissionalRoadmapName = 'profissionalRoadmap';
  static const String perfilProfissionalName = 'perfilProfissional';


  static GoRouter createRouter({
    String? initialLocation,
    required AuthProvider authProvider,
  }) {
    return GoRouter(
      initialLocation: initialLocation ?? LoginPage.route, // Use constant
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: LoginPage.route, // Use constant
          name: loginName, // Use name constant
          builder: (context, state) {
            final user = authProvider.currentUser;
            if (user == null) {
              return const LoginPage();
            } else if (authProvider.userType == 'paciente') {
              return PacienteMainPage(state: state, child: const PacienteHomePage());
            } else if (authProvider.userType == 'profissional') {
              return ProfissionalMainPage(
                state: state,
                child: const ProfissionalHomePage(),
              );
            }
            return const LoginPage();
          },
        ),
        GoRoute(
          path: SignUpPage.route, // Use constant
          name: signupName, // Use name constant
          builder: (context, state) => const SignUpPage(),
        ),
        ShellRoute(
          builder:
              (context, state, child) =>
                  PacienteMainPage(state: state, child: child),
          routes: [
            GoRoute(
              path: PacienteHomePage.route, // Use constant
              name: homePacienteName, // Use name constant
              builder: (context, state) => const PacienteHomePage(),
            ),
            GoRoute(
              path: ProfissionalSearchPage.route, // Use constant
              name: pacienteBuscaName, // Use name constant
              builder: (context, state) => const ProfissionalSearchPage(),
            ),
            GoRoute(
              path: ProfissionalPerfilPublicoPage.route, // Use constant
              name: perfilPublicoProfissionalName, // Use name constant
              builder: (context, state) {
                final profissional = state.extra as Profissional?;
                return ProfissionalPerfilPublicoPage(
                  key: ValueKey(profissional?.id),
                );
              },
            ),
            GoRoute(
              path: PacientesAgendamentosPage.route, // Use constant
              name: calendarioName, // Use name constant
              builder: (context, state) => const PacientesAgendamentosPage(),
            ),
            GoRoute(
              path: '/paciente/perfil', // PerfilPage route is context-dependent
              name: perfilPacienteName, // Use name constant
              builder: (context, state) => const PerfilPage(),
            ),
          ],
        ),
        ShellRoute(
          builder:
              (context, state, child) =>
                  ProfissionalMainPage(state: state, child: child),
          routes: [
            GoRoute(
              path: ProfissionalHomePage.route, // Use constant
              name: homeProfissionalName, // Use name constant
              builder: (context, state) => const ProfissionalHomePage(),
            ),
            GoRoute(
              path: ProfissionalAgendamentosPage.route, // Use constant
              name: profissionalAgendamentosName, // Use name constant
              builder: (context, state) => const ProfissionalAgendamentosPage(),
            ),
            GoRoute(
              path: ProfissionalRoadmapPage.route, // Already using constant
              name: profissionalRoadmapName, // Use name constant
              builder: (context, state) => const ProfissionalRoadmapPage(),
            ),
            GoRoute(
              path: '/profissional/perfil', // PerfilPage route is context-dependent
              name: perfilProfissionalName, // Use name constant
              builder: (context, state) => const PerfilPage(),
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
            location != LoginPage.route && // Use constant
            location != SignUpPage.route) { // Use constant
          return LoginPage.route;  // Redirecionar para login, não para a raiz
        }

        // Se o usuário estiver autenticado e tentar acessar login
        if (user != null && location == LoginPage.route) { // Use constant
          if (authProvider.userType == 'paciente') {
            return PacienteHomePage.route; // Use constant
          } else if (authProvider.userType == 'profissional') {
            return ProfissionalHomePage.route; // Use constant
          }
        }

        return null; // Sem redirecionamento
      },
      errorBuilder: (context, state) => const LoginPage(),
    );
  }
}

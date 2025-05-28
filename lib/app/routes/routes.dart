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
import 'package:careflow_app/app/features/profissional/profissional_roadmap_page.dart'; 

sealed class Routes {
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
      initialLocation: initialLocation ?? LoginPage.route, 
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: LoginPage.route, 
          name: loginName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: SignUpPage.route, 
          name: signupName, 
          builder: (context, state) => const SignUpPage(),
        ),
        ShellRoute(
          builder:
              (context, state, child) =>
                  PacienteMainPage(state: state, child: child),
          routes: [
            GoRoute(
              path: PacienteHomePage.route, 
              name: homePacienteName, 
              builder: (context, state) => const PacienteHomePage(),
            ),
            GoRoute(
              path: ProfissionalSearchPage.route,
              name: pacienteBuscaName,
              builder: (context, state) => const ProfissionalSearchPage(),
            ),
            GoRoute(
              path: ProfissionalPerfilPublicoPage.route,
              builder: (context, state) {
                final profissional = state.extra as Profissional?;
                return ProfissionalPerfilPublicoPage(
                  key: ValueKey(profissional?.id),
                );
              },
            ),
            GoRoute(
              path: PacientesAgendamentosPage.route,
              name: calendarioName,
              builder: (context, state) => const PacientesAgendamentosPage(),
            ),
            GoRoute(
              path: '/paciente/perfil',
              name: perfilPacienteName,
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
              path: ProfissionalHomePage.route,
              name: homeProfissionalName,
              builder: (context, state) => const ProfissionalHomePage(),
            ),
            GoRoute(
              path: ProfissionalAgendamentosPage.route,
              name: profissionalAgendamentosName,
              builder: (context, state) => const ProfissionalAgendamentosPage(),
            ),
            GoRoute(
              path: ProfissionalRoadmapPage.route,
              name: profissionalRoadmapName,
              builder: (context, state) => const ProfissionalRoadmapPage(),
            ),
            GoRoute(
              path: '/profissional/perfil', 
              name: perfilProfissionalName, 
              builder: (context, state) => const PerfilPage(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {

        if (!authProvider.initialized) {
          return null; 
        }
        
        final user = authProvider.currentUser;
        final location = state.uri.toString();

       
        if (user == null &&
            location != LoginPage.route &&
            location != SignUpPage.route) {
          return LoginPage.route;
        }

       
        if (user != null && location == LoginPage.route) {
          if (authProvider.userType == 'paciente') {
            return PacienteHomePage.route;
          }
        }

        return null;
      },
      errorBuilder: (context, state) => const LoginPage(),
    );
  }
}

import 'package:careflow_app/app/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PacienteMainPage extends StatelessWidget {
  const PacienteMainPage({super.key, required this.state, required this.child});
  final Widget child;
  final GoRouterState state;

  static const List<String> _routes = [
    '/paciente/home',
    '/paciente/consultas',
    '/paciente/perfil',
  ];

  @override
  Widget build(BuildContext context) {
    final String location = state.uri.toString();

    return Scaffold(
      body: Stack(
        children: [
          // Conteúdo da página atual
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 76),
              child: child,
            ),
          ),
          // Barra de navegação flutuante
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: NavBarWidget(
              onTap: (index) {
                context.go(_routes[index]); // Navegação via GoRouter
              },
              selectedIndex: _routes.indexOf(location),
            ),
          ),
        ],
      ),
    );
  }
}

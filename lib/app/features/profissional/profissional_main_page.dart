import 'package:careflow_app/app/widgets/nav_bar/nav_bar_item.dart';
import 'package:careflow_app/app/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/routes/routes.dart';

class ProfissionalMainPage extends StatelessWidget {
  const ProfissionalMainPage({
    super.key,
    required this.state,
    required this.child,
  });

  final Widget child;
  final GoRouterState state;

  static const List<NavBarItem> _navItems = [
    NavBarItem(icon: Icons.home, label: 'Home'),
    NavBarItem(icon: Icons.calendar_today, label: 'Agendamentos'),
    NavBarItem(icon: Icons.map, label: 'Roadmap'),
    NavBarItem(icon: Icons.person, label: 'Perfil'),
  ];

  static const List<String> _routes = [
    '/profissional/home',
    Routes.profissionalAgendamentos,
    '/profissional/roadmap',
    '/profissional/perfil',
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
              items: _navItems, // Ícones e rótulos dinâmicos
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:careflow_app/app/widgets/app_bars/default_app_bar_widget.dart';
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
      appBar: DefaultAppBar(
      title: 'Agendamentos',
      userName: 'Dr. Silva',
      userImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBwuP-lo9ZtcJc7iOj6X-wksnZIcSRorecaIW5UnKkqM0OnMhmoY-xkk-3OXzg6kkPOObNRLEb_Y50oeWzBds8eo7YuP4dfhi4tz3JRas84dQJUseeqXN-DXb7_IGE6IIBmcNYGo0UlOQgXQsr2v5umwVToOYjZjaRaeiFZiIxeHp3xchLInTrR7y7W6JvX4CQBFsU5ihSvpi6gVqY2G37W1OZ6adu0EAB3rr7u6uqylbIocSmQqoonA1QdsK79-f7W2vt-G801vPFx',
      userRole: 'Médico',
      onNotificationPressed: () {
        // TODO: Implementar navegação para notificações
      },
      onProfilePressed: () {
        // TODO: Implementar navegação para perfil
      },
    ),
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

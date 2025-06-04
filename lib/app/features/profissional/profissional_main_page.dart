import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/widgets/app_bars/default_app_bar_widget.dart';
import 'package:careflow_app/app/widgets/nav_bar/nav_bar_item.dart';
import 'package:careflow_app/app/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/features/auth/login/login_page.dart'; 
import 'package:careflow_app/app/features/profissional/profissional_home_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_agendamentos_page.dart';
import 'package:careflow_app/app/features/profissional/roadmap/profissional_roadmap_page.dart';

class ProfissionalMainPage extends StatefulWidget {
  const ProfissionalMainPage({
    super.key,
    required this.state,
    required this.child,
  });

  final Widget child;
  final GoRouterState state;

  @override
  State<ProfissionalMainPage> createState() => _ProfissionalMainPageState();
}

class _ProfissionalMainPageState extends State<ProfissionalMainPage> {
  Profissional? _profissional;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfissionalData();
  }

  Future<void> _loadProfissionalData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profissionalProvider = Provider.of<ProfissionalProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      final profissional = await profissionalProvider.getProfissionalById(authProvider.currentUser!.uid);
      if (mounted) {
        setState(() {
          _profissional = profissional;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  static const List<NavBarItem> _navItems = [
    NavBarItem(icon: Icons.home, label: 'Home'),
    NavBarItem(icon: Icons.calendar_today, label: 'Agendamentos'),
    NavBarItem(icon: Icons.map, label: 'Roadmap'),
    NavBarItem(icon: Icons.person, label: 'Perfil'),
  ];

  static final List<String> _routes = [
    ProfissionalHomePage.route,
    ProfissionalAgendamentosPage.route,
    ProfissionalRoadmapPage.route,
    '/profissional/perfil', // TODO: AJUSTAR PerfilPage route is defined directly in routes.dart for professionals
  ];

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authProvider.signOut();
      if (context.mounted) {
        context.go(LoginPage.route); // Use LoginPage.route
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = widget.state.uri.toString();
    final isPerfilPage = location.startsWith('/profissional/perfil');

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: DefaultAppBar(
        title: isPerfilPage ? 'Perfil' : 'Agendamentos',
        userName: _profissional?.nome ?? 'Profissional',
        userImageUrl: 'https://via.placeholder.com/150',
        userRole: _profissional?.especialidade ?? 'Profissional',
        showNotificationIcon: !isPerfilPage,
        showLogoutButton: isPerfilPage,
        onLogoutPressed: _handleLogout,
        onNotificationPressed: () {
          // TODO: Implementar navegação para notificações
        },
        onProfilePressed: isPerfilPage 
            ? null 
            : () => context.go('/profissional/perfil'), // This specific string is fine as it's unique to this context
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 76),
              child: widget.child,
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: NavBarWidget(
              onTap: (index) {
                context.go(_routes[index]);
              },
              selectedIndex: _routes.indexWhere((route) => location.startsWith(route.split('/').take(3).join('/'))),
              items: _navItems,
            ),
          ),
        ],
      ),
    );
  }
}

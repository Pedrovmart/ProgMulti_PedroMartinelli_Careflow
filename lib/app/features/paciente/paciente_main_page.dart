import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/features/perfil/perfil_controller.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:careflow_app/app/widgets/app_bars/default_app_bar_widget.dart';
import 'package:careflow_app/app/widgets/nav_bar/nav_bar_item.dart';
import 'package:careflow_app/app/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PacienteMainPage extends StatefulWidget {
  const PacienteMainPage({super.key, required this.state, required this.child});
  final Widget child;
  final GoRouterState state;

  @override
  State<PacienteMainPage> createState() => _PacienteMainPageState();
}

class _PacienteMainPageState extends State<PacienteMainPage> {
  Paciente? _paciente;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPacienteData();
    _initPerfilController();
  }

  void _initPerfilController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<PerfilController>(context, listen: false).init();
      }
    });
  }

  Future<void> _loadPacienteData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final pacienteProvider = Provider.of<PacienteProvider>(
      context,
      listen: false,
    );

    if (authProvider.currentUser != null) {
      final paciente = await pacienteProvider.getPacienteById(
        authProvider.currentUser!.uid,
      );
      if (mounted) {
        setState(() {
          _paciente = paciente;
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
    NavBarItem(icon: Icons.search, label: 'Busca'),
    NavBarItem(icon: Icons.calendar_today, label: 'Consultas'),
    NavBarItem(icon: Icons.person, label: 'Perfil'),
  ];

  static const List<String> _routes = [
    '/paciente/home',
    '/paciente/busca',
    '/paciente/calendario',
    '/paciente/perfil',
  ];

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
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
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = widget.state.uri.toString();
    final isPerfilPage = location.startsWith('/paciente/perfil');

    return Consumer<PerfilController>(
      builder: (context, perfilController, _) {
        if (_isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Usa a imagem do perfil do controlador
        final imageUrl = perfilController.profileImageUrl;

        return Scaffold(
          appBar: DefaultAppBar(
            title: isPerfilPage ? 'Perfil' : 'Paciente',
            userName: _paciente?.nome ?? 'Paciente',
            userImageUrl: imageUrl,
            userRole: 'Paciente',
            showNotificationIcon: !isPerfilPage,
            showLogoutButton: isPerfilPage,
            onLogoutPressed: _handleLogout,
            onNotificationPressed: () {
              // TODO: Implementar navegação para notificações
            },
            onProfilePressed:
                isPerfilPage ? null : () => context.go('/paciente/perfil'),
          ),
          body: Stack(
            children: [
              widget.child,
              Align(
                alignment: Alignment.bottomCenter,
                child: NavBarWidget(
                  onTap: (index) {
                    context.go(_routes[index]);
                  },
                  selectedIndex: _routes.indexWhere(
                    (route) => location.startsWith(route),
                  ),
                  items: _navItems,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

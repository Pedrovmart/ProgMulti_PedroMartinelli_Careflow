import 'package:careflow_app/app/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/features/paciente/paciente_home_page.dart';

class PacienteMainPage extends StatefulWidget {
  const PacienteMainPage({super.key});

  @override
  State<PacienteMainPage> createState() {
    return _PacienteMainPageState();
  }
}

class _PacienteMainPageState extends State<PacienteMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPageContent() {
    switch (_selectedIndex) {
      case 0:
        return PacienteHomePage();
      case 1:
        return Center(child: Text("Consultas"));
      case 2:
        return Center(child: Text("Perfil"));
      default:
        return Center(child: Text("Página Inicial"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 76),
              child: _getPageContent(),
            ),
          ),
          // Barra de navegação flutuante
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: NavBarWidget(
              onTap: _onItemTapped,
              selectedIndex: _selectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:careflow_app/app/presentation/pages/profissional/home/profissional_home_page.dart';
import 'package:careflow_app/app/widgets/nav_bar/nav_bar_widget.dart';
import 'package:flutter/material.dart';

class ProfissionalMainPage extends StatefulWidget {
  const ProfissionalMainPage({super.key});

  @override
  State<ProfissionalMainPage> createState() => _ProfissionalMainPageState();
}

class _ProfissionalMainPageState extends State<ProfissionalMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPageContent() {
    switch (_selectedIndex) {
      case 0:
        return ProfissionalHomePage();
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
              padding: const EdgeInsets.only(
                bottom: 76,
              ), // Espaço para a navbar
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

import 'package:flutter/material.dart';

class PacienteMainPage extends StatefulWidget {
  const PacienteMainPage({super.key});

  @override
  State<PacienteMainPage> createState() {
    return _PacienteMainPageState();
  }
}

class _PacienteMainPageState extends State<PacienteMainPage> {
  int _selectedIndex = 0;

  // Lista de Widgets que representam o conteúdo principal (body) de cada aba
  final List<Widget> _pages = [
    HomePacientePage(),
    BuscarPage(),
    AgendamentosPage(),
    PerfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitleForIndex(_selectedIndex))),
      body: _pages[_selectedIndex], // Só troca o body
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agendamentos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // Define o título da AppBar conforme o índice selecionado
  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Início';
      case 1:
        return 'Buscar';
      case 2:
        return 'Agendamentos';
      case 3:
        return 'Perfil';
      default:
        return 'Paciente';
    }
  }
}

// Cada uma dessas classes representa apenas o conteúdo da tela
class HomePacientePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Bem-vindo à Home do Paciente'));
  }
}

class BuscarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Página de Busca'));
  }
}

class AgendamentosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Seus Agendamentos'));
  }
}

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Seu Perfil'));
  }
}

import 'package:flutter/material.dart';

class ProfissionalMainPage extends StatelessWidget {
  const ProfissionalMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Profissional'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Lógica para fazer logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de navegação fixa
          NavigationBar(),

          // Título das consultas agendadas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Consultas Agendadas",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // Exibindo a lista de consultas
          Expanded(
            child: ListView.builder(
              itemCount:
                  5, // Este número será dinâmico com base nos dados do Firebase
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Paciente ${index + 1}'),
                    subtitle: Text('Consulta: 10:00 AM - 15/05/2025'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Lógica para editar consulta
                        Navigator.pushNamed(context, '/edit-appointment');
                      },
                    ),
                    onTap: () {
                      // Lógica para visualizar consulta
                      Navigator.pushNamed(context, '/appointment-details');
                    },
                  ),
                );
              },
            ),
          ),

          // Botão para adicionar uma nova consulta
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Lógica para adicionar nova consulta
                Navigator.pushNamed(context, '/add-appointment');
              },
              child: const Text('Adicionar Nova Consulta'),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/agenda');
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}

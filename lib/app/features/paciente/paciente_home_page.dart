import 'package:flutter/material.dart';

class PacienteHomePage extends StatelessWidget {
  const PacienteHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Área do Paciente'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, Paciente!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.teal),
                title: Text('Próximas Consultas'),
                subtitle: Text('Veja suas consultas agendadas'),
                onTap: () {
                  // Navegar para a página de consultas
                },
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.map, color: Colors.teal),
                title: Text('Rota Atual'),
                subtitle: Text(
                  'Você está em: ${ModalRoute.of(context)?.settings.name ?? "Desconhecida"}',
                ),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.history, color: Colors.teal),
                title: Text('Histórico Médico'),
                subtitle: Text('Acesse seu histórico de saúde'),
                onTap: () {
                  // Navegar para a página de histórico médico
                },
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.teal),
                title: Text('Perfil'),
                subtitle: Text('Atualize suas informações pessoais'),
                onTap: () {
                  // Navegar para a página de perfil
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

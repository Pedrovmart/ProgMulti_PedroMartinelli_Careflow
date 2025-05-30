import 'package:flutter/material.dart';
import 'paciente_home_controller.dart';

class PacienteHomePage extends StatelessWidget {
  PacienteHomePage({super.key});

  final PacienteHomeController _controller = PacienteHomeController();


  static const String route = '/paciente/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _controller.navigateToConsultas(context);
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
                  _controller.navigateToHistoricoMedico(context);
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
                  _controller.navigateToPerfil(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

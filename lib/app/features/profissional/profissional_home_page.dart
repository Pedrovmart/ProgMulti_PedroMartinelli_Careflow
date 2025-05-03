import 'package:flutter/material.dart';

class ProfissionalHomePage extends StatelessWidget {
  const ProfissionalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Profissional'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo, Dr. João!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: const Text('Consultas Agendadas'),
                subtitle: const Text(
                  'Confira as consultas marcadas para hoje.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navegar para a página de consultas
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.timeline, color: Colors.green),
                title: const Text('Roadmap de Pacientes'),
                subtitle: const Text(
                  'Acompanhe o progresso dos seus pacientes.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navegar para o roadmap de pacientes
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notificações Recentes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('- Consulta com Maria às 14:00.'),
                    const Text('- Novo paciente adicionado ao roadmap.'),
                    const Text('- Atualização no prontuário de José.'),
                    const SizedBox(height: 16),
                    const Text(
                      'Rota Atual:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final routeName =
                            ModalRoute.of(context)?.settings.name ??
                            'Rota desconhecida';
                        return Text(
                          routeName,
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

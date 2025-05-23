import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/profissional_model.dart';

class ProfissionalPerfilPublicoPage extends StatelessWidget {
  const ProfissionalPerfilPublicoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o profissional do contexto
    final profissional =
        ModalRoute.of(context)?.settings.arguments as Profissional?;

    if (profissional == null) {
      return Scaffold(
        body: const Center(
          child: Text('Dados do profissional não encontrados.'),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(90, 0, 0, 0),
                child: const Icon(Icons.person, size: 50, color: Colors.white),
                //TODO: BLOCO PARA QUANDO USER TIVER IMAGEM
                /*                 backgroundImage:
                    profissional.fotoUrl != null
                        ? NetworkImage(profissional.fotoUrl!)
                        : null,
                child:
                    profissional.fotoUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null, */
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                profissional.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                profissional.especialidade,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            const Divider(height: 32),
            Text('Contato:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Email: ${profissional.email}'),
            Text('Telefone: ${profissional.telefone ?? 'Não disponível'}'),
            const SizedBox(height: 16),
            Text('Sobre:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              /* profissional.sobre ?? */ 'Informações não disponíveis',
            ), //TODO: Quando tiver item soobre de profissional ajustar
          ],
        ),
      ),
    );
  }
}

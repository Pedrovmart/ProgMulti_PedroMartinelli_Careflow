import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/features/profissional/widgets/profissional_search_card.dart';
import 'package:careflow_app/app/features/profissional/profissional_perfil_publico_page.dart';

class ProfissionalSearchPage extends StatefulWidget {
  const ProfissionalSearchPage({super.key});

  @override
  State<ProfissionalSearchPage> createState() => _ProfissionalSearchPageState();
}

class _ProfissionalSearchPageState extends State<ProfissionalSearchPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch profissionais when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfissionalProvider>(
        context,
        listen: false,
      ).fetchProfissionais();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profissionalProvider = Provider.of<ProfissionalProvider>(context);
    final profissionais =
        profissionalProvider.profissionais
            .where(
              (profissional) => profissional.nome.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Profissionais')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child:
                profissionais.isEmpty
                    ? const Center(
                      child: Text('Nenhum profissional encontrado.'),
                    )
                    : ListView.builder(
                      itemCount: profissionais.length,
                      itemBuilder: (context, index) {
                        final profissional = profissionais[index];
                        return GestureDetector(
                          onTap: () {
                            // Navega para a página de perfil do profissional
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const ProfissionalPerfilPublicoPage(),
                                settings: RouteSettings(
                                  arguments: profissional,
                                ),
                              ),
                            );
                          },
                          child: ProfissionalSearchCard(
                            nome: profissional.nome,
                            especialidade: profissional.especialidade,
                            numeroRegistro: profissional.numeroRegistro,
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
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
      appBar: AppBar(
        title: const Text('Buscar Profissionais'),
        // AppBar styling will be inherited from AppTheme.appBarTheme
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                // TextField labelText and prefixIcon colors will be derived from ThemeData.colorScheme
                // Input text style will use ThemeData.textTheme.bodyLarge or bodyMedium
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
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
                    ? Center(
                      child: Text(
                        'Nenhum profissional encontrado.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryDark.withValues(alpha: 0.7),
                            ),
                      ),
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

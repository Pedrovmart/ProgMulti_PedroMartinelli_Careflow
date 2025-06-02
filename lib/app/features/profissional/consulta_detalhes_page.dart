import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/profissional/controllers/consulta_detalhes_controller.dart';

class ConsultaDetalhesPage extends StatelessWidget {
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;

  const ConsultaDetalhesPage({
    super.key,
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
  });

  static const String route = '/profissional/consulta-detalhes';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConsultaDetalhesController(
        Provider.of<ConsultasProvider>(context, listen: false),
      )..carregarDetalhesConsulta(
          idProfissional: idProfissional,
          idPaciente: idPaciente,
        ),
      child: _ConsultaDetalhesView(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
        nomePaciente: nomePaciente,
      ),
    );
  }
}

class _ConsultaDetalhesView extends StatelessWidget {
  final String idProfissional;
  final String idPaciente;
  final String nomePaciente;
  
  const _ConsultaDetalhesView({
    required this.idProfissional,
    required this.idPaciente,
    required this.nomePaciente,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConsultaDetalhesController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: _buildBody(context, controller, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConsultaDetalhesController controller,
    ThemeData theme,
  ) {
    if (controller.isLoading) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Container com sombra para o card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gif de carregamento
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/loading_animation.gif',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Título
                    const Text(
                      'Processando Informações',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Mensagem personalizada
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Aguarde alguns minutos, estamos gerando o roadmap personalizado do paciente com base nas informações fornecidas. Este processo pode levar alguns instantes.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Indicador de progresso com texto
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Carregando...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Nota informativa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Dica: Este processo utiliza inteligência artificial para gerar recomendações personalizadas. Quanto mais detalhadas as informações, melhores serão os resultados!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.errorMessage != null) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Ícone de erro
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 32),
              // Título do erro
              const Text(
                'Ocorreu um erro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Mensagem de erro
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  controller.errorMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // Botão para tentar novamente
              ElevatedButton(
                onPressed: () {
                  // Recarregar a página
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConsultaDetalhesPage(
                        idProfissional: idProfissional,
                        idPaciente: idPaciente,
                        nomePaciente: nomePaciente,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Tentar Novamente',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Link para voltar
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Voltar',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.markdownContent == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum conteúdo disponível para esta consulta.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Recarregar a página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultaDetalhesPage(
                      idProfissional: idProfissional,
                      idPaciente: idPaciente,
                      nomePaciente: nomePaciente,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Voltar',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Detalhes da Consulta',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: md.Markdown(
                  data: controller.markdownContent!,
                  styleSheet: md.MarkdownStyleSheet(
                    h1: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                    p: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.black87,
                    ),
                    strong: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border(
                        left: BorderSide(
                          color: AppColors.primary,
                          width: 4.0,
                        ),
                      ),
                    ),
                    code: TextStyle(
                      backgroundColor: Colors.grey[200],
                      fontFamily: 'monospace',
                      fontSize: 13.0,
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

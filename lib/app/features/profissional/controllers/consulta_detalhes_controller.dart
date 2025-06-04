import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

class ConsultaDetalhesController extends ChangeNotifier {
  final ConsultasProvider _consultasProvider;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  Map<String, dynamic>? _detalhesConsulta;
  Map<String, dynamic>? get detalhesConsulta => _detalhesConsulta;
  
  String? _markdownContent;
  String? get markdownContent => _markdownContent;
  
  // Constantes para mensagens
  static const String tituloProcessando = 'Processando Informações';
  static const String mensagemProcessando = 'Aguarde alguns minutos, estamos gerando o roadmap personalizado do paciente com base nas informações fornecidas. Este processo pode levar alguns instantes.';
  static const String tituloErro = 'Ocorreu um erro';
  static const String textoBotaoTentarNovamente = 'Tentar Novamente';
  static const String textoBotaoVoltar = 'Voltar';
  static const String mensagemSemConteudo = 'Nenhum conteúdo disponível para esta consulta.';
  static const String dicaProcessamento = 'Dica: Este processo utiliza inteligência artificial para gerar recomendações personalizadas. Quanto mais detalhadas as informações, melhores serão os resultados!';
  
  // Estilo do Markdown
  md.MarkdownStyleSheet get markdownStyle => md.MarkdownStyleSheet(
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
      border: const Border(
        left: BorderSide(
          color: AppColors.primary,
          width: 4.0,
        ),
      ),
    ),
    code: const TextStyle(
      backgroundColor: Color(0xFFEEEEEE),
      fontFamily: 'monospace',
      fontSize: 13.0,
    ),
    codeblockDecoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(4.0),
    ),
  );

  ConsultaDetalhesController(this._consultasProvider);

  /// Carrega os detalhes da consulta do profissional para o paciente
  Future<void> carregarDetalhesConsulta({
    required String idProfissional,
    required String idPaciente,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _detalhesConsulta = await _consultasProvider.getDetalhesConsultaProfissionalPaciente(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
      );
      
      // Extrai o conteúdo markdown da resposta
      _markdownContent = _detalhesConsulta?['output'] as String?;
      
      if (_markdownContent == null) {
        throw Exception('Conteúdo da consulta não encontrado');
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar detalhes da consulta: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Retorna o estilo do container de loading
  BoxDecoration get loadingContainerDecoration => BoxDecoration(
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
  );
  
  /// Retorna o estilo do container de erro
  BoxDecoration get errorContainerDecoration => BoxDecoration(
    color: Colors.red.withValues(alpha: 0.1),
    shape: BoxShape.circle,
  );
  
  /// Retorna o estilo do card de conteúdo
  BoxDecoration get contentCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(12.0),
    border: Border.all(
      color: AppColors.primaryLight.withValues(alpha: 0.5),
      width: 1.0,
    ),
  );
  
  /// Retorna o estilo do botão primário
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
  
  /// Retorna o estilo do botão de texto
  TextStyle get textButtonStyle => const TextStyle(
    color: AppColors.primary,
    fontSize: 14,
  );

  /// Atualiza o diagnóstico do paciente
  Future<void> atualizarDiagnostico({
    required String idProfissional,
    required String idPaciente,
    required String novoDiagnostico,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Aqui você deve implementar a lógica para atualizar o diagnóstico
      // usando o _consultasProvider
      await Future.delayed(const Duration(seconds: 1)); // Simulação de chamada de API
      
      // Recarrega os detalhes da consulta para refletir as alterações
      await carregarDetalhesConsulta(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
      );
    } catch (e) {
      _errorMessage = 'Erro ao atualizar diagnóstico: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

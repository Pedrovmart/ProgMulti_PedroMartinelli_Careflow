import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

class ConsultaDetalhesController extends ChangeNotifier {
  String? _idConsulta;
  String? get idConsulta => _idConsulta;
  final ConsultasProvider _consultasProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _detalhesConsulta;
  Map<String, dynamic>? get detalhesConsulta => _detalhesConsulta;

  String? _markdownContent;
  String? get markdownContent => _markdownContent;

  String? _conteudoSemFormatacao;
  String? get conteudoSemFormatacao => _conteudoSemFormatacao;

  static const String tituloProcessando = 'Processando Informações';
  static const String mensagemProcessando =
      'Aguarde alguns minutos, estamos gerando o roadmap personalizado do paciente com base nas informações fornecidas. Este processo pode levar alguns instantes.';
  static const String tituloErro = 'Ocorreu um erro';
  static const String textoBotaoTentarNovamente = 'Tentar Novamente';
  static const String textoBotaoVoltar = 'Voltar';
  static const String mensagemSemConteudo =
      'Nenhum conteúdo disponível para esta consulta.';
  static const String dicaProcessamento =
      'Dica: Este processo utiliza inteligência artificial para gerar recomendações personalizadas. Quanto mais detalhadas as informações, melhores serão os resultados!';

  md.MarkdownStyleSheet get markdownStyle => md.MarkdownStyleSheet(
    h1: AppTextStyles.headlineLarge.copyWith(
      color: AppColors.primaryDark,
      fontWeight: FontWeight.bold,
    ),
    h2: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.primaryDark,
      fontWeight: FontWeight.bold,
    ),
    p: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
    strong: const TextStyle(fontWeight: FontWeight.bold),
    em: const TextStyle(fontStyle: FontStyle.italic),
  );

  ConsultaDetalhesController(this._consultasProvider);

  Future<void> carregarDetalhesConsulta({
    required String idProfissional,
    required String idPaciente,
    String? idConsulta,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _idConsulta = idConsulta;
    notifyListeners();

    try {
      _detalhesConsulta = await _consultasProvider
          .getDetalhesConsultaProfissionalPaciente(
            idProfissional: idProfissional,
            idPaciente: idPaciente,
          );

      _markdownContent = _detalhesConsulta?['output'] as String?;

      if (_markdownContent != null && _markdownContent!.isNotEmpty) {
        _markdownContent = _corrigirFormatacaoMarkdown(_markdownContent!);
      } else {
        _markdownContent = mensagemSemConteudo;
      }


    } catch (e) {
      _errorMessage = 'Erro ao carregar os detalhes da consulta: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _removerFormatacaoMarkdown(String markdown) {
    if (markdown.isEmpty) return '';

    String texto = markdown.replaceAll(RegExp(r'^#+\s*', multiLine: true), '');

    texto = texto.replaceAll(RegExp(r'[*_]{1,3}(.*?)[*_]{1,3}'), r'$1');

    texto = texto.replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1');

    texto = texto.replaceAll(RegExp(r'^[\s]*[-*+]\s', multiLine: true), '');

    texto = texto.replaceAll(RegExp(r'```[\s\S]*?```', multiLine: true), '');

    texto = texto.replaceAll(RegExp(r'^>\s*', multiLine: true), '');

    texto = texto.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return texto.trim();
  }

  String _corrigirFormatacaoMarkdown(String markdown) {
    if (markdown.isEmpty) return '';

    String texto = markdown.replaceAllMapped(
      RegExp(r'^(#{1,6})([^\s#])', multiLine: true),
      (m) => '${m[1]} ${m[2]}',
    );

    return texto;
  }

  void atualizarConteudoSemFormatacao() {
    _conteudoSemFormatacao = _removerFormatacaoMarkdown(_markdownContent ?? '');
    notifyListeners();
  }

  Future<void> atualizarDiagnostico({
    required BuildContext context,
    required String idProfissional,
    required String idPaciente,
    required String novoDiagnostico,
  }) async {
    if (_idConsulta == null) {
      throw Exception('ID da consulta não disponível');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _consultasProvider.atualizarDiagnostico(
        idConsulta: _idConsulta!,
        diagnostico: novoDiagnostico,
      );
      
      if (_detalhesConsulta != null) {
        _detalhesConsulta!['diagnostico'] = novoDiagnostico;
        
        if (_markdownContent != null && _markdownContent!.contains('Diagnóstico')) {
          
        }
      }
    } catch (e) {
      _errorMessage = 'Erro ao atualizar o diagnóstico: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

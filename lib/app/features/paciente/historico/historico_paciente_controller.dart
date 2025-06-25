import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';

enum HistoricoPacienteUiState {
  loading,
  error,
  empty,
  content
}

class HistoricoPacienteController extends ChangeNotifier {
  final PacienteProvider _pacienteProvider;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic>? _historicoData;
  String? _markdownContent;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<dynamic>? get historicoData => _historicoData;
  String? get markdownContent => _markdownContent;
  
  HistoricoPacienteUiState get uiState {
    if (_isLoading && _historicoData == null) {
      return HistoricoPacienteUiState.loading;
    }
    
    if (_errorMessage != null) {
      return HistoricoPacienteUiState.error;
    }
    
    if (_historicoData == null || _historicoData!.isEmpty || _markdownContent == null) {
      return HistoricoPacienteUiState.empty;
    }
    
    return HistoricoPacienteUiState.content;
  }

  final String mensagemSemConteudo = 
      "# Histórico não disponível\n\nNão há histórico disponível para este paciente.";
      
  MarkdownStyleSheet get markdownStyle => MarkdownStyleSheet(
    h1: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.primaryDark,
      fontWeight: FontWeight.bold,
    ),
    h2: AppTextStyles.titleLarge.copyWith(
      color: AppColors.primaryDark,
      fontWeight: FontWeight.bold,
    ),
    h3: AppTextStyles.titleMedium.copyWith(
      color: AppColors.primaryDark,
      fontWeight: FontWeight.w600,
    ),
    p: AppTextStyles.bodyMedium,
    strong: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
    em: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
    blockquote: AppTextStyles.bodyMedium.copyWith(
      color: Colors.grey[700],
      fontStyle: FontStyle.italic,
    ),
    blockquoteDecoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(4.0),
      border: Border.all(color: Colors.grey[300]!),
    ),
    blockquotePadding: const EdgeInsets.all(16.0),
  );

  HistoricoPacienteController(this._pacienteProvider);

  Future<void> carregarHistoricoPaciente({
    required String pacienteId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final historicoList = await _pacienteProvider.getHistoricoPaciente(
        pacienteId: pacienteId,
      );

      _historicoData = historicoList;
      
      if (_historicoData != null && _historicoData!.isNotEmpty) {
        _markdownContent = _historicoData!.first['output'] as String?;
      }
      
      if (_markdownContent == null || _markdownContent!.isEmpty) {
        _markdownContent = mensagemSemConteudo;
      }
    } catch (e) {
      log('Erro ao carregar histórico do paciente: $e');
      _errorMessage = 'Erro ao carregar o histórico do paciente: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

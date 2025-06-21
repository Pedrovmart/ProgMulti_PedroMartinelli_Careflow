import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';

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

  final String mensagemSemConteudo = 
      "# Histórico não disponível\n\nNão há histórico disponível para este paciente.";
      
  final MarkdownStyleSheet? markdownStyle = null;

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

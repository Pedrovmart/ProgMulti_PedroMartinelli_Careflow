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

  // Create a properly configured ThemeData with all required text styles
  final MarkdownStyleSheet markdownStyle = MarkdownStyleSheet.fromTheme(
    ThemeData(
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 14.0, color: Colors.black54),
        bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black),
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    ),
  ).copyWith(
    h1: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    h2: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    h3: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    p: const TextStyle(
      fontSize: 16,
      color: Colors.black87,
      height: 1.5,
    ),
    listBullet: const TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
    strong: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
    em: const TextStyle(
      fontStyle: FontStyle.italic,
    ),
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
        // Assumindo que o primeiro item contém o output com o markdown
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

import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';

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

  ConsultaDetalhesController(this._consultasProvider);

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
}

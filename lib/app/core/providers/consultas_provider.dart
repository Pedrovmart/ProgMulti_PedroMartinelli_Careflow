import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/repositories/repository_manager.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class ConsultasProvider extends ChangeNotifier {
  final _consultasRepository =
      RepositoryManager().get<N8nConsultasRepository>();

  List<ConsultaModel> _consultas = [];
  bool _isLoading = false;
  String? _error;

  // Construtor vazio - o repositório é obtido através do RepositoryManager
  ConsultasProvider();

  List<ConsultaModel> get consultas => _consultas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Método para adicionar consultas de teste (apenas para demonstração)
  void setConsultasForTesting(List<ConsultaModel> consultas) {
    _consultas = consultas;
    notifyListeners();
  }

  // Limpa os erros
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Busca todas as consultas agendadas
  Future<void> fetchConsultasAgendadas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _consultas = await _consultasRepository.getAll();
    } catch (e) {
      _error = "Erro ao buscar consultas agendadas: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConsultasPorPaciente(String pacienteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _consultas = await _consultasRepository.getByPacienteId(pacienteId);
    } catch (e) {
      _error = "Erro ao buscar consultas do paciente: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agendarConsulta(ConsultaModel consulta) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultasRepository.agendarConsulta(consulta);
      await fetchConsultasAgendadas();
    } catch (e) {
      _error = "Erro ao agendar consulta: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarConsulta(ConsultaModel consulta) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final consultaId = consulta.id;
      if (consultaId == null) {
        throw Exception('ID da consulta não encontrado');
      }

      await _consultasRepository.update(consultaId, consulta);
      await fetchConsultasAgendadas();
    } catch (e) {
      _error = "Erro ao atualizar consulta: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelarConsulta(String consultaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultasRepository.cancelarConsulta(consultaId);
      await fetchConsultasAgendadas();
    } catch (e) {
      _error = "Erro ao cancelar consulta: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ConsultaModel?> fetchConsultaById(String consultaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final consulta = await _consultasRepository.fetchConsultaById(consultaId);
      return consulta;
    } catch (e) {
      _error = "Erro ao buscar consulta pelo ID: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Busca uma consulta específica pelo ID (alternativa usando o método base)
  Future<ConsultaModel?> getConsultaById(String consultaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final consulta = await _consultasRepository.getById(consultaId);
      return consulta;
    } catch (e) {
      _error = "Erro ao buscar consulta pelo ID: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

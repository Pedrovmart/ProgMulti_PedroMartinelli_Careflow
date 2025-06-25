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

  ConsultasProvider();

  List<ConsultaModel> get consultas => _consultas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

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
  
  Future<void> atualizarDiagnostico({
    required String idConsulta,
    required String diagnostico,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultasRepository.atualizarDiagnostico(
        idConsulta: idConsulta,
        diagnostico: diagnostico,
      );
    } catch (e) {
      _error = 'Erro ao atualizar diagnóstico: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConsultasPorProfissional(String profissionalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _consultas = await _consultasRepository.getByProfissionalId(profissionalId);
    } catch (e) {
      _error = "Erro ao buscar consultas do profissional: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> agendarConsulta(ConsultaModel consulta) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final consultaId = await _consultasRepository.agendarConsulta(consulta);
      return consultaId;
    } catch (e) {
      _error = "ConsultasProvider -Erro ao agendar consulta: ${e.toString()}";
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


  Future<void> atualizarConsultaParcial(String consultaId, Map<String, dynamic> fieldsToUpdate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultasRepository.updatePartialFields(consultaId, fieldsToUpdate);
      await fetchConsultasAgendadas(); 
    } catch (e) {
      _error = "Erro ao atualizar parcialmente a consulta: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> cancelarConsulta(String consultaId) async {

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      final success = await _consultasRepository.cancelarConsulta(consultaId);
      
      if (success) {
        await fetchConsultasAgendadas();
        return true;
      } else {
        _error = "Não foi possível cancelar a consulta. Por favor, tente novamente.";
        return false;
      }

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

  Future<Map<String, dynamic>> getDetalhesConsultaProfissionalPaciente({
    required String idProfissional,
    required String idPaciente,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final detalhes = await _consultasRepository.getDetalhesConsultaProfissionalPaciente(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
      );
      return detalhes;
    } catch (e) {
      _error = "Erro ao buscar detalhes da consulta: ${e.toString()}";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

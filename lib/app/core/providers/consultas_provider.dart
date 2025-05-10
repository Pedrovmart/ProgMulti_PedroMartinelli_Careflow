import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/core/repositories/consultas_repository.dart';

class ConsultasProvider extends ChangeNotifier {
  final ConsultasRepository _consultasRepository;

  ConsultasProvider(this._consultasRepository);

  List<ConsultaModel> _consultas = [];
  bool _isLoading = false;

  List<ConsultaModel> get consultas => _consultas;
  bool get isLoading => _isLoading;

  // Busca todas as consultas agendadas
  Future<void> fetchConsultasAgendadas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _consultas = await _consultasRepository.fetchConsultasAgendadas();
    } catch (e) {
      throw Exception("Erro ao buscar consultas agendadas: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agenda uma nova consulta
  Future<void> agendarConsulta(ConsultaModel consulta) async {
    try {
      await _consultasRepository.agendarConsulta(consulta);
      _consultas.add(consulta);
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao agendar consulta: ${e.toString()}");
    }
  }

  // Cancela uma consulta pelo ID
  Future<void> cancelarConsulta(String consultaId) async {
    try {
      await _consultasRepository.cancelarConsulta(consultaId);
      _consultas =
          _consultas.where((consulta) => consulta.id != consultaId).toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao cancelar consulta: ${e.toString()}");
    }
  }

  // Busca uma consulta específica pelo ID
  Future<ConsultaModel?> fetchConsultaById(String consultaId) async {
    try {
      return await _consultasRepository.fetchConsultaById(consultaId);
    } catch (e) {
      throw Exception("Erro ao buscar consulta pelo ID: ${e.toString()}");
    }
  }
}

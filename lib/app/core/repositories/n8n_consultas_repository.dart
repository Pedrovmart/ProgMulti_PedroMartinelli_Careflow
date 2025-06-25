
import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'dart:developer';


class N8nConsultasRepository implements BaseRepository<ConsultaModel> {
  final N8nHttpClient _httpClient;

  final String _endpointConsultasPaciente = '/consultasPaciente';
  final String _endpointConsultasProfissional = '/consultasProfissional';
  final String _endpointNovaConsulta = '/novaConsulta';
  final String _endpointGetConsultas = '/consultas';
  final String _endpointUpdateConsulta = '/atualizaConsulta';
  final String _endpointDeleteConsulta = '/cancelarConsulta';
  final String _endpointConsultaProfissionalPaciente = '/consultasProfissionalPaciente';
  final String _endpointAtualizarDiagnostico = '/atualizaDiagnostico';

  N8nConsultasRepository(this._httpClient);

  @override
  Future<List<ConsultaModel>> getAll() async {
    try {
      final response = await _httpClient.get(_endpointGetConsultas);
      final List<dynamic> data = response.data ?? []; 
      return data
          .whereType<Map<String, dynamic>>()
          .where((item) => _isValidConsultaMap(item))
          .map((item) {
            log('N8nConsultasRepository.getAll - Raw item from API: $item');
            return ConsultaModel.fromMap(item);
          })
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar TODAS as consultas : $e');
    }
  }


  Future<List<ConsultaModel>> getByPacienteId(String pacienteId) async {
    try {
      final response = await _httpClient.get(
        _endpointConsultasPaciente,
        queryParameters: {'pacienteId': pacienteId},
      );

      final List<dynamic> data = response.data ?? []; 

      return data
          .whereType<Map<String, dynamic>>()
          .where((item) => _isValidConsultaMap(item))
          .map((item) {
            log('N8nConsultasRepository.getByPacienteId - Raw item from API: $item');
            return ConsultaModel.fromMap(item);
          })
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar consultas do paciente: $e');
    }
  }
  
  Future<List<ConsultaModel>> getByProfissionalId(String profissionalId) async {
    try {
      final response = await _httpClient.get(
        _endpointConsultasProfissional,
        queryParameters: {'idMedico': profissionalId},
      );

      final List<dynamic> data = response.data ?? []; 

      return data
          .whereType<Map<String, dynamic>>()
          .where((item) => _isValidConsultaMap(item))
          .map((item) {
            log('N8nConsultasRepository.getByProfissionalId - Raw item from API: $item');
            return ConsultaModel.fromMap(item);
          })
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar consultas do profissional: $e');
    }
  }

  @override
  Future<ConsultaModel?> getById(String id) async {
    throw UnimplementedError('Este método não é utilizado por este repositório.');
  }

  @override
  Future<ConsultaModel> create(ConsultaModel item) async {
    try {
      final response = await _httpClient.post(_endpointNovaConsulta, data: item.toMap());
      return ConsultaModel.fromMap(response.data);
    } catch (e) {
      throw Exception('Erro ao criar consulta: $e');
    }
  }

  @override
  Future<void> update(String id, ConsultaModel item) async {
    try {
      // Delega para o método updatePartialFields que usa o endpoint /atualizaConsulta
      await updatePartialFields(id, item.toMap());
    } catch (e) {
      log('Erro ao atualizar consulta: $e');
      throw Exception('Erro ao atualizar consulta: $e');
    }
  }

  Future<void> updatePartialFields(String consultaId, Map<String, dynamic> fieldsToUpdate) async {
    try {
      await _httpClient.put(
        _endpointUpdateConsulta,
       queryParameters: {'idConsulta': consultaId},
       data: fieldsToUpdate);
    } catch (e) {
      throw Exception('Erro ao atualizar campos da consulta: $e');
    }
  }

  Future<void> atualizarDiagnostico({
    required String idConsulta,
    required String diagnostico,
  }) async {
    try {
      final url = '$_endpointAtualizarDiagnostico?idConsulta=$idConsulta';
      await _httpClient.put(
        url,
        data: {'diagnostico': diagnostico},
      );
    } catch (e) {
      throw Exception('Erro ao atualizar diagnóstico: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _httpClient.delete('$_endpointDeleteConsulta/$id');
    } catch (e) {
      throw Exception('Erro ao deletar consulta: $e');
    }
  }

  Future<void> cancelarConsulta(String consultaId) => delete(consultaId);

  bool _isValidConsultaMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      log('Consulta inválida: mapa vazio');
      return false;
    }

    final hasId = map['id'] != null || map['_id'] != null || map['idConsulta'] != null;
    final hasEssentialData = map['idMedico'] != null || map['idPaciente'] != null;
    
    final isValid = hasId && hasEssentialData;
    
    if (!isValid) {
      log('Consulta inválida: faltam campos obrigatórios. Map: $map');
    }
    
    return isValid;
  }

  // ESSA É A MANEIRA CORRETA PARA MIM FAZER 
  Future<List<ConsultaModel>> fetchConsultasAgendadas() => getAll();

  Future<String> agendarConsulta(ConsultaModel consulta) async {
    try {
      final response = await _httpClient.post(_endpointNovaConsulta, data: consulta.toMap());
      if (response.data is String) {
        return response.data;
      } else if (response.data is Map<String, dynamic>) {
        final consultaObj = ConsultaModel.fromMap(response.data);
        return consultaObj.id ?? '';
      }
      return '';
    } catch (e) {
      throw Exception('Erro ao criar consulta: $e');
    }
  }


  Future<ConsultaModel?> fetchConsultaById(String consultaId) =>
      getById(consultaId);
      
  Future<Map<String, dynamic>> getDetalhesConsultaProfissionalPaciente({
    required String idProfissional,
    required String idPaciente,
  }) async {
    try {
      final response = await _httpClient.get(
        _endpointConsultaProfissionalPaciente,
        queryParameters: {
          'idProfissional': idProfissional,
          'idPaciente': idPaciente,
        },
      );
      
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Formato de resposta inesperado do servidor');
      }
    } catch (e) {
      throw Exception('Erro ao buscar detalhes da consulta: $e');
    }
  }


}

import 'package:dio/dio.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/models/consulta_model.dart';


class N8nConsultasRepository implements BaseRepository<ConsultaModel> {
  final N8nHttpClient _httpClient;

  // Endpoints específicos
  final String _endpointConsultasPaciente = '/consultasPaciente';
  final String _endpointNovaConsulta = '/novaConsulta';
  final String _endpointGetConsultas = '/consultas';
  final String _endpointUpdateConsulta = '/atualizarConsulta';
  final String _endpointDeleteConsulta = '/cancelarConsulta';
  final String _endpointplaceholder = '/placeholder';

  N8nConsultasRepository(this._httpClient);

  @override
  Future<List<ConsultaModel>> getAll() async {
    try {
      final response = await _httpClient.get(_endpointGetConsultas);
      final List<dynamic> data = response.data;
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => ConsultaModel.fromMap(item))
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

      final List<dynamic> data = response.data;

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => ConsultaModel.fromMap(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar consultas do paciente: $e');
    }
  }

  @override //TODO:nao é necessário
  Future<ConsultaModel?> getById(String id) async {
    try {
      final response = await _httpClient.get('$_endpointplaceholder/$id');
      return ConsultaModel.fromMap(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Erro ao buscar consulta: $e');
    }
  }

  @override //TODO: nao é necessario
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
      await _httpClient.put('$_endpointUpdateConsulta/$id', data: item.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar consulta: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _httpClient.delete('$_endpointDeleteConsulta/$id');
    } catch (e) {
      throw Exception('Erro ao remover consulta: $e');
    }
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

  Future<void> cancelarConsulta(String consultaId) => delete(consultaId);

  Future<ConsultaModel?> fetchConsultaById(String consultaId) =>
      getById(consultaId);
}

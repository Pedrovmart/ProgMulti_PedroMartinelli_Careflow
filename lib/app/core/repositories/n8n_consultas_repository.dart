import 'package:dio/dio.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/models/consulta_model.dart';


class N8nConsultasRepository implements BaseRepository<ConsultaModel> {
  final N8nHttpClient _httpClient;

  // Endpoints específicos
  final String _endpointConsultasPaciente = '/consultasPaciente';
  final String _endpointNovaConsulta = '/novaConsulta';
  final String _endpointGetConsulta = '/consulta';
  final String _endpointUpdateConsulta = '/atualizarConsulta';
  final String _endpointDeleteConsulta = '/cancelarConsulta';

  N8nConsultasRepository(this._httpClient);

  @override
  Future<List<ConsultaModel>> getAll() async {
    try {
      final response = await _httpClient.get(_endpointNovaConsulta);
      final List<dynamic> data = response.data;
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => ConsultaModel.fromMap(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar TODAS as consultas : $e');
    }
  }

  @override
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

  @override
  Future<ConsultaModel?> getById(String id) async {
    try {
      final response = await _httpClient.get('$_endpointGetConsulta/$id');
      return ConsultaModel.fromMap(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Erro ao buscar consulta: $e');
    }
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

  // Métodos específicos do domínio de consultas

  /// Busca todas as consultas agendadas (alias para getAll)
  Future<List<ConsultaModel>> fetchConsultasAgendadas() => getAll();

  /// Agenda uma nova consulta (alias para create)
  Future<void> agendarConsulta(ConsultaModel consulta) => create(consulta);

  /// Cancela uma consulta pelo ID (alias para delete)
  Future<void> cancelarConsulta(String consultaId) => delete(consultaId);

  /// Busca uma consulta específica pelo ID (alias para getById)
  Future<ConsultaModel?> fetchConsultaById(String consultaId) =>
      getById(consultaId);
}

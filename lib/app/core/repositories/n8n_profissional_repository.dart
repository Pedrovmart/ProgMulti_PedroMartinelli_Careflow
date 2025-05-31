import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:dio/dio.dart';
import 'package:careflow_app/app/models/profissional_model.dart';

class N8nProfissionalRepository implements BaseRepository<Profissional> {
  final N8nHttpClient _httpClient;

  // Endpoints específicos para profissionais
  final String _endpointBase = '/profissionais';
  final String _endpointGetAll = '/profissionais';
  final String _endpointGetById = '/profissional';
  final String _endpointCreate = '/novoProfissional';
  final String _endpointUpdate = '/atualizarProfissional';
  final String _endpointDelete = '/excluirProfissional';

  N8nProfissionalRepository(this._httpClient);

  @override
  Future<List<Profissional>> getAll() async {
    try {
      final response = await _httpClient.get(_endpointGetAll);
      final List<dynamic> data = response.data;

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => Profissional.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar todos os profissionais: $e');
    }
  }

  //TODO: VERIFICAR SE VAI SER NECESSARIA IMPLEMENTAÇÃO
  Future<List<Profissional>> getByPacienteId(String pacienteId) async {
    // Se não houver um endpoint específico para buscar profissionais por paciente,
    // podemos retornar todos e filtrar localmente ou lançar uma exceção
    return getAll();
  }

  @override
  Future<Profissional?> getById(String id) async {
    try {
      final response = await _httpClient.get(
        _endpointGetById,
        queryParameters: {'id': id},
      );

      if (response.data == null) {
        return null;
      }

      if (response.data is List) {
        final listData = response.data as List;
        if (listData.isNotEmpty && listData.first is Map<String, dynamic>) {
          return Profissional.fromJson(listData.first as Map<String, dynamic>);
        } else {
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        return Profissional.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Formato de dados inesperado recebido da API para profissional ID: $id');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Erro de comunicação ao buscar profissional por ID: $id. Detalhes: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar profissional por ID: $id. Detalhes: $e');
    }
  }

  @override //Atualmente feito pelo auth do FB
  Future<Profissional> create(Profissional profissional) async {
    try {
      final response = await _httpClient.post(
        _endpointCreate,
        data: _toRequestData(profissional),
      );

      return Profissional.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar profissional: $e');
    }
  }

  @override
  Future<void> update(String id, Profissional profissional) async {
    try {
      await _httpClient.put(
        '$_endpointUpdate/$id',
        data: _toRequestData(profissional),
      );
    } catch (e) {
      throw Exception('Erro ao atualizar profissional: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _httpClient.delete('$_endpointDelete/$id');
    } catch (e) {
      throw Exception('Erro ao remover profissional: $e');
    }
  }

  // Métodos auxiliares

  Map<String, dynamic> _toRequestData(Profissional profissional) {
    final data = profissional.toJson();

    data.remove('userType');

    data['id'] = profissional.id;
    data['nome'] = profissional.nome;
    data['email'] = profissional.email;
    data['especialidade'] = profissional.especialidade;
    data['numRegistro'] = profissional.numeroRegistro;
    data['idEmpresa'] = profissional.idEmpresa;

    if (profissional.dataNascimento != null) {
      data['dataNascimento'] = profissional.dataNascimento;
    }

    if (profissional.telefone != null) {
      data['telefone'] = profissional.telefone;
    }

    return data;
  }

  // Métodos específicos do domínio de profissionais

  Future<List<Profissional>> getByEspecialidade(String especialidade) async {
    try {
      final response = await _httpClient.get(
        _endpointBase,
        queryParameters: {'especialidade': especialidade},
      );

      final List<dynamic> data = response.data is List ? response.data : [];

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => Profissional.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar profissionais por especialidade: $e');
    }
  }

  Future<List<Profissional>> getByEmpresa(String empresaId) async {
    try {
      final response = await _httpClient.get(
        _endpointBase,
        queryParameters: {'idEmpresa': empresaId},
      );

      final List<dynamic> data = response.data is List ? response.data : [];

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => Profissional.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar profissionais por empresa: $e');
    }
  }
}

import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
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

  @override
  Future<List<Profissional>> getByPacienteId(String pacienteId) async {
    // Se não houver um endpoint específico para buscar profissionais por paciente,
    // podemos retornar todos e filtrar localmente ou lançar uma exceção
    // Esta implementação retorna todos os profissionais (pode ser ajustada conforme necessidade)
    return getAll();
  }

  @override
  Future<Profissional?> getById(String id) async {
    try {
      final response = await _httpClient.get('$_endpointGetById/$id');
      return Profissional.fromJson(response.data);
    } catch (e) {
      // Se o erro for 404 (não encontrado), retorna null
      if (e.toString().contains('404')) {
        return null;
      }
      throw Exception('Erro ao buscar profissional por ID: $e');
    }
  }

  @override //Atualmente feito pelo auth do FB
  Future<Profissional> create(Profissional profissional) async {
    try {
      final response = await _httpClient.post(
        _endpointCreate, 
        data: _toRequestData(profissional),
      );
      
      // Retorna o profissional com o ID atualizado (se necessário)
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
  
  /// Converte um objeto Profissional para o formato esperado pela API
  Map<String, dynamic> _toRequestData(Profissional profissional) {
    final data = profissional.toJson();
    
    // Remover campos que não devem ser enviados ou que são gerenciados pelo servidor

    data.remove('userType');
    
    // Garantir que campos obrigatórios estejam presentes
    data['id'] = profissional.id;
    data['nome'] = profissional.nome;
    data['email'] = profissional.email;
    data['especialidade'] = profissional.especialidade;
    data['numRegistro'] = profissional.numeroRegistro;
    data['idEmpresa'] = profissional.idEmpresa;
    
    // Adicionar campos opcionais apenas se estiverem preenchidos
    if (profissional.dataNascimento != null) {
      data['dataNascimento'] = profissional.dataNascimento;
    }
    
    if (profissional.telefone != null) {
      data['telefone'] = profissional.telefone;
    }
    
    return data;
  }
  
  // Métodos específicos do domínio de profissionais
  
  /// Busca profissionais por especialidade
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
  
  /// Busca profissionais por empresa
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

import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class N8nPacienteRepository implements BaseRepository<Paciente> {
  final N8nHttpClient _httpClient;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _endpointGetAll = '/pacientes';
  final String _endpointGetById = '/paciente';
  final String _endpointCreate = '/novoPaciente';
  final String _endpointUpdate = '/atualizarPaciente';
  final String _endpointDelete = '/excluirPaciente';
  final String _endpointPerfilPaciente = '/perfilPaciente';

  N8nPacienteRepository(this._httpClient);

  @override
  Future<List<Paciente>> getAll() async {
    try {
      final response = await _httpClient.get(_endpointGetAll);
      
      if (response.data == null) {
        return [];
      }
      
      if (response.data is Map<String, dynamic>) {
        final paciente = Paciente.fromJson(response.data);
        return [paciente];
      }
      
      if (response.data is List) {
        final List<dynamic> data = response.data;
        return data
            .whereType<Map<String, dynamic>>()
            .map((item) => Paciente.fromJson(item))
            .toList();
      }
      
      return [];
    } catch (e) {
      log('Erro ao buscar todos os pacientes: $e');
      return [];
    }
  }


  @override
  Future<Paciente?> getById(String id) async {
    try {
      final response = await _httpClient.get(
        _endpointGetById,
        queryParameters: {'id': id},
      );
      
      if (response.data == null) {
        log('Resposta vazia ao buscar paciente');
        return null;
      }
      
      log('Dados recebidos: ${response.data}');
      
      final responseData = response.data is Map<String, dynamic> 
          ? response.data 
          : Map<String, dynamic>.from(response.data);
          
      return Paciente.fromJson(responseData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        log('Paciente não encontrado para o ID: $id');
        return null;
      }
      log('Erro ao buscar paciente: ${e.message}');
      if (e.response != null) {
        log('Dados da resposta: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('Erro inesperado ao buscar paciente: $e');
      rethrow;
    }
  }

  @override
  Future<Paciente> create(Paciente paciente) async {
    try {
      final response = await _httpClient.post(
        _endpointCreate, 
        data: _toRequestData(paciente),
      );
      
      return Paciente.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar paciente: $e');
    }
  }

  @override
  Future<void> update(String id, Paciente paciente) async {
    try {
      await _httpClient.put(
        '$_endpointUpdate/$id', 
        data: _toRequestData(paciente),
      );
    } catch (e) {
      throw Exception('Erro ao atualizar paciente: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _httpClient.delete('$_endpointDelete/$id');
    } catch (e) {
      throw Exception('Erro ao remover paciente: $e');
    }
  }

  /// Converte um objeto Paciente para o formato esperado pela API
  Map<String, dynamic> _toRequestData(Paciente paciente) {
    final data = paciente.toJson();
    
    // Remover campos que não devem ser enviados ou que são gerenciados pelo servidor
    data.remove('userType');
    
    // Garantir que campos obrigatórios estejam presentes
    data['id'] = paciente.id;
    data['nome'] = paciente.nome;
    data['email'] = paciente.email;
    data['cpf'] = paciente.cpf;
    data['dataNascimento'] = paciente.dataNascimento.toIso8601String();
    data['telefone'] = paciente.telefone;
    data['endereco'] = paciente.endereco;
    
    return data;
  }

  // Métodos específicos para o perfil do paciente
  
  /// Busca o perfil completo do paciente
  Future<Paciente?> getPerfil(String pacienteId) async {
    try {
      final response = await _httpClient.get(
        '$_endpointPerfilPaciente/$pacienteId'
      );
      
      if (response.statusCode == 404) {
        log('Perfil do paciente não encontrado com ID: $pacienteId');
        return null;
      }
      
      return Paciente.fromJson(response.data);
    } catch (e) {
      log('Erro ao buscar perfil do paciente: $e');
      throw Exception('Erro ao buscar perfil do paciente: $e');
    }
  }

  /// Atualiza o perfil do paciente
  Future<void> atualizarPerfil(Paciente paciente) async {
    try {
      await _httpClient.put(
        '$_endpointPerfilPaciente/${paciente.id}',
        data: _toRequestData(paciente),
      );
    } catch (e) {
      throw Exception('Erro ao atualizar perfil do paciente: $e');
    }
  }

  // Métodos para gerenciamento de imagens de perfil
  
  /// Upload da imagem de perfil do paciente
  Future<String?> uploadProfileImage(String pacienteId, File imageFile) async {
    try {
      // Usamos o Firebase Storage para armazenar as imagens
      final ref = _storage.ref().child('profile_images').child('$pacienteId.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      
      // Atualiza a URL da imagem no perfil do paciente via n8n
      await _httpClient.put(
        '$_endpointPerfilPaciente/$pacienteId/imagem',
        data: {'profileImageUrl': url},
      );
      
      return url;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  /// Obter URL da imagem de perfil do paciente
  Future<String?> getProfileImageUrl(String pacienteId) async {
    try {
      // Primeiro tentamos buscar do n8n
      try {
        final response = await _httpClient.get(
          '$_endpointPerfilPaciente/$pacienteId/imagem',
        );
        
        if (response.data is Map<String, dynamic> && 
            response.data.containsKey('profileImageUrl')) {
          return response.data['profileImageUrl'];
        }
      } catch (_) {
        // Se falhar, tentamos diretamente do Firebase Storage
      }
      
      // Tentativa direta do Firebase Storage
      final ref = _storage.ref().child('profile_images').child('$pacienteId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      // Imagem não existe, não é um erro
      return null;
    }
  }
}

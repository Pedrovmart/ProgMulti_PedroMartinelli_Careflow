import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/core/services/storage_service.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class N8nProfissionalRepository implements BaseRepository<Profissional> {
  final N8nHttpClient _httpClient;
  final StorageService _storageService;

  final String _endpointBase = '/profissionais';
  final String _endpointGetAll = '/profissionais';
  final String _endpointGetById = '/profissional';
  final String _endpointCreate = '/novoProfissional';
  final String _endpointUpdate = '/atualizaUser';
  final String _endpointDelete = '/excluirProfissional';
  final String _endpointEspecialidades = '/especialidades';

  N8nProfissionalRepository(this._httpClient, {StorageService? storageService})
    : _storageService = storageService ?? StorageService();

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
        throw Exception(
          'Formato de dados inesperado recebido da API para profissional ID: $id',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception(
        'Erro de comunicação ao buscar profissional por ID: $id. Detalhes: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Erro inesperado ao buscar profissional por ID: $id. Detalhes: $e',
      );
    }
  }

  @override
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
      final data = _toRequestData(profissional);
      data['userType'] = 'profissionais';

      await _httpClient.put(
        _endpointUpdate,
        queryParameters: {'idUser': id},
        data: data,
      );
    } catch (e) {
      log('Erro ao atualizar profissional: $e');
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

    if (profissional.dataNascimento != null) {
      data['dataNascimento'] = profissional.dataNascimento;
    }

    if (profissional.telefone != null) {
      data['telefone'] = profissional.telefone;
    }

    if (profissional.profileUrlImage != null) {
      data['profileUrlImage'] = profissional.profileUrlImage;
    }

    return data;
  }

  Future<String> uploadProfileImage(
    String profissionalId,
    File imageFile,
  ) async {
    try {
      final imageUrl = await _storageService.uploadFile(
        file: imageFile,
        folder: 'users_images',
        fileName:
            'profissional_$profissionalId${path.extension(imageFile.path)}',
      );

      await _httpClient.put(
        '/atualizaImagemUser?idUser=$profissionalId',
        data: {'profileImageUrl': imageUrl, 'userType': 'profissionais'},
      );

      return imageUrl;
    } catch (e) {
      log('Erro ao fazer upload da imagem de perfil: $e');
      throw Exception('Não foi possível fazer upload da imagem de perfil: $e');
    }
  }

  Future<String?> getProfileImageUrl(String profissionalId) async {
    try {
      final profissional = await getById(profissionalId);
      if (profissional?.profileUrlImage != null &&
          profissional!.profileUrlImage!.isNotEmpty) {
        return profissional.profileUrlImage;
      }

      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('users_images')
            .child('profissional_$profissionalId');

        final result = await ref.listAll();

        if (result.items.isNotEmpty) {
          return await result.items.first.getDownloadURL();
        }
      } catch (e) {
        log('Imagem não encontrada no storage: $e');
      }

      return null;
    } catch (e) {
      log('Erro ao obter URL da imagem de perfil: $e');
      return null;
    }
  }

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

  Future<List<String>> getEspecialidades() async {
    try {
      final response = await _httpClient.get(_endpointEspecialidades);
      
      if (response.data != null) {
        final List<dynamic> data = response.data is List ? response.data : [];
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => json['especialidade'].toString())
            .toList();
      } else {
        log('Resposta vazia do endpoint de especialidades');
        throw Exception('Falha ao carregar especialidades');
      }
    } catch (e) {
      log('Exceção ao buscar especialidades: $e');
      throw Exception('Erro ao conectar com o servidor');
    }
  }
}

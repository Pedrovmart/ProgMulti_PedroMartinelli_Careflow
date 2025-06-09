import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/core/services/storage_service.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:path/path.dart' as path;

class N8nPacienteRepository implements BaseRepository<Paciente> {
  final N8nHttpClient _httpClient;
  final StorageService _storageService;

  final String _endpointGetAll = '/pacientes';
  final String _endpointGetById = '/paciente';
  final String _endpointCreate = '/novoPaciente';
  final String _endpointUpdate = '/atualizarPaciente';
  final String _endpointDelete = '/excluirPaciente';

  N8nPacienteRepository(this._httpClient, {StorageService? storageService})
    : _storageService = storageService ?? StorageService();

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

      final responseData =
          response.data is Map<String, dynamic>
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

    // Adicionar campo de imagem de perfil se existir
    if (paciente.profileUrlImage != null) {
      data['profileUrlImage'] = paciente.profileUrlImage;
    }

    return data;
  }

  // Métodos para gerenciamento de imagens de perfil

  /// Faz upload ou atualiza a imagem de perfil do paciente
  ///
  /// [pacienteId] - ID do paciente
  /// [imageFile] - Arquivo de imagem a ser enviado
  /// Retorna a URL da imagem após o upload
  Future<String> uploadProfileImage(String pacienteId, File imageFile) async {
    try {
      log('Iniciando upload da imagem de perfil para o paciente $pacienteId');

      // Garante que a extensão esteja em minúsculas
      final fileExtension = path.extension(imageFile.path).toLowerCase();
      final fileName = 'paciente_$pacienteId$fileExtension';

      log('Nome do arquivo a ser salvo: $fileName');

      // Faz upload da imagem para o Firebase Storage
      final imageUrl = await _storageService.uploadFile(
        file: imageFile,
        folder: 'users_images',
        fileName: fileName,
      );

      log('Imagem enviada com sucesso para: $imageUrl');

      try {
        log('Atualizando perfil do paciente com a nova URL da imagem');
        // Atualiza o perfil do paciente com a nova URL da imagem
        await _httpClient.put(
          '/atualizaImagemUser',
          queryParameters: {'idUser': pacienteId},
          data: {'profileImageUrl': imageUrl, 'userType': 'pacientes'},
        );
        log('Perfil do paciente atualizado com sucesso');
      } catch (e) {
        log('Erro ao atualizar perfil do paciente: $e');
        // Não interrompe o fluxo, pois o upload da imagem já foi bem-sucedido
      }

      return imageUrl;
    } catch (e, stackTrace) {
      log('Erro ao fazer upload da imagem de perfil: $e');
      log('Stack trace: $stackTrace');
      throw Exception('Não foi possível fazer upload da imagem de perfil: $e');
    }
  }

  Future<String?> getProfileImageUrl(String pacienteId) async {
    try {
      final paciente = await getById(pacienteId);

      if (paciente?.profileUrlImage?.isNotEmpty ?? false) {
        String url = paciente!.profileUrlImage!;
        return url;
      }

      return null;
    } catch (e) {
      log('Erro ao obter URL da imagem de perfil: $e');
      return null;
    }
  }
}

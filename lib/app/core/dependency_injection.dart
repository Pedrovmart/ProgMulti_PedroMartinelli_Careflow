import 'dart:developer';

import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_paciente_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_profissional_repository.dart';
import 'package:careflow_app/app/core/repositories/repository_manager.dart';
import 'package:careflow_app/app/core/services/storage_service.dart';

class DependencyInjection {
  static bool _initialized = false;
  static late final N8nHttpClient _httpClient;
  static late final RepositoryManager _repositoryManager;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      _httpClient = N8nHttpClient();
      _repositoryManager = RepositoryManager();

      final storageService = StorageService();

      _repositoryManager.register<N8nPacienteRepository>(
        N8nPacienteRepository(_httpClient, storageService: storageService),
      );
      _repositoryManager.register<N8nProfissionalRepository>(
        N8nProfissionalRepository(_httpClient, storageService: storageService),
      );
      _repositoryManager.register<N8nConsultasRepository>(
        N8nConsultasRepository(_httpClient),
      );

      _initialized = true;

      log('Dependências inicializadas com sucesso');
      log('Conectado ao n8n em: ${_httpClient.baseUrl}');
    } catch (e) {
      log('Erro ao inicializar dependências: $e');
      rethrow;
    }
  }

  static N8nHttpClient get httpClient {
    if (!_initialized) throw Exception("DependencyInjection não inicializado.");
    return _httpClient;
  }

  static N8nConsultasRepository get consultasRepository {
    if (!_initialized) throw Exception("DependencyInjection não inicializado.");
    return _repositoryManager.getConsultasRepository();
  }

  static N8nPacienteRepository get pacienteRepository {
    if (!_initialized) throw Exception("DependencyInjection não inicializado.");
    return _repositoryManager.getPacienteRepository();
  }

  static N8nProfissionalRepository get profissionalRepository {
    if (!_initialized) throw Exception("DependencyInjection não inicializado.");
    return _repositoryManager.getProfissionalRepository();
  }

  static void reset() {
    if (_initialized) {
      _repositoryManager.reset();
    }
    _initialized = false;
  }
}

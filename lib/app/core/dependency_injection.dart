import 'dart:developer';

import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_paciente_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_profissional_repository.dart';
import 'package:careflow_app/app/core/repositories/repository_manager.dart';

class DependencyInjection {
  static bool _initialized = false;
  static late final N8nHttpClient _httpClient;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      _httpClient = N8nHttpClient();
      
      final repositoryManager = RepositoryManager();
      
      repositoryManager.register<N8nPacienteRepository>(N8nPacienteRepository(_httpClient));
      repositoryManager.register<N8nProfissionalRepository>(N8nProfissionalRepository(_httpClient));
      repositoryManager.register<N8nConsultasRepository>(N8nConsultasRepository(_httpClient));
      
      _initialized = true;
      
      log('Dependências inicializadas com sucesso');
      log('Conectado ao n8n em: ${_httpClient.baseUrl}');
    } catch (e) {
      log('Erro ao inicializar dependências: $e');
      rethrow;
    }
  }
  
  static N8nHttpClient get httpClient => _httpClient;
  
  static N8nConsultasRepository get consultasRepository => 
      RepositoryManager().getConsultasRepository();
      
  static N8nPacienteRepository get pacienteRepository => 
      RepositoryManager().getPacienteRepository();
      
  static N8nProfissionalRepository get profissionalRepository => 
      RepositoryManager().getProfissionalRepository();
  
  static void reset() {
    _initialized = false;
  }
}

import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';
import 'package:careflow_app/app/core/repositories/repository_manager.dart';

class DependencyInjection {
  static bool _initialized = false;
  static late final N8nHttpClient _httpClient;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      _httpClient = N8nHttpClient();
      RepositoryManager();
      
      _initialized = true;
      
      print('Dependências inicializadas com sucesso');
      print('Conectado ao n8n em: ${_httpClient.baseUrl}');
    } catch (e) {
      print('Erro ao inicializar dependências: $e');
      rethrow;
    }
  }
  
  static N8nHttpClient get httpClient => _httpClient;
  
  static N8nConsultasRepository get consultasRepository => 
      N8nConsultasRepository(httpClient);
  
  static void reset() {
    _initialized = false;
  }
}

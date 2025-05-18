import 'package:careflow_app/app/core/http/n8n_http_client.dart';
import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';

class RepositoryManager {
  static final RepositoryManager _instance = RepositoryManager._internal();
  final N8nHttpClient _httpClient = N8nHttpClient();
  
  final Map<Type, dynamic> _repositories = {};
  bool _initialized = false;

  factory RepositoryManager() {
    return _instance;
  }

  RepositoryManager._internal() {
    _initialize();
  }

  void _initialize() {
    if (!_initialized) {
      _repositories[N8nConsultasRepository] = N8nConsultasRepository(_httpClient);
      
      _initialized = true;
    }
  }

  T get<T>() {
    if (_repositories.containsKey(T)) {
      return _repositories[T] as T;
    }

    throw Exception('Repositório não encontrado: $T');
  }

  void register<T>(T repository) {
    _repositories[T] = repository;
  }
  void reset() {
    _repositories.clear();
    _initialized = false;
    _initialize();
  }
}

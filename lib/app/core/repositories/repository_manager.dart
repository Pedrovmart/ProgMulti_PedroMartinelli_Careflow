import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_paciente_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_profissional_repository.dart';

class RepositoryManager {
  static final RepositoryManager _instance = RepositoryManager._internal();
  
  final Map<Type, dynamic> _repositories = {};

  factory RepositoryManager() {
    return _instance;
  }

  RepositoryManager._internal();

  T get<T>() {
    if (_repositories.containsKey(T)) {
      return _repositories[T] as T;
    }

    throw Exception('Repositório não encontrado: $T. Certifique-se de que foi registrado.');
  }
  
  N8nPacienteRepository getPacienteRepository() {
    return get<N8nPacienteRepository>();
  }
  
  N8nProfissionalRepository getProfissionalRepository() {
    return get<N8nProfissionalRepository>();
  }
  
  N8nConsultasRepository getConsultasRepository() {
    return get<N8nConsultasRepository>();
  }

  void register<T>(T repository) {
    _repositories[T.runtimeType] = repository; //  runtimeType para garantir o tipo correto como chave
  }

  void reset() {
    _repositories.clear();
  }
}

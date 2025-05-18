/// Interface base para todos os repositórios que interagem com a API
abstract class BaseRepository<T> {
  /// Busca todos os itens
  Future<List<T>> getAll();
  
  /// Busca itens por paciente
  Future<List<T>> getByPacienteId(String pacienteId);
  
  /// Busca um item pelo ID
  Future<T?> getById(String id);
  
  /// Cria um novo item
  Future<T> create(T item);
  
  /// Atualiza um item existente
  Future<void> update(String id, T item);
  
  /// Remove um item
  Future<void> delete(String id);
}

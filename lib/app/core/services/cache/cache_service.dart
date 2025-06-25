import 'dart:async';

/// Interface para serviço de cache
abstract class CacheService {
  /// Verifica se uma chave existe no cache
  bool has(String key);
  
  /// Obtém um valor do cache
  T? get<T>(String key);
  
  /// Armazena um valor no cache com tempo de expiração opcional
  void set<T>(String key, T value, {Duration? expiry});
  
  /// Remove um item específico do cache
  void remove(String key);
  
  /// Limpa todo o cache ou uma categoria específica
  void clear({String? category});
  
  /// Obtém um valor do cache ou executa a função fornecida se não existir ou estiver expirado
  Future<T> getOrFetch<T>(
    String key, 
    Future<T> Function() fetchFunction, 
    {Duration? expiry}
  );
  
  /// Atualiza um valor no cache apenas se ele já existir
  void updateIfExists<T>(String key, T value);
}

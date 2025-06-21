import 'package:flutter/material.dart';
import '../services/cache/cache_service.dart';
import '../services/cache/memory_cache_service.dart';

class CacheProvider extends ChangeNotifier {
  final CacheService _cacheService;
  
  CacheProvider({CacheService? cacheService}) 
      : _cacheService = cacheService ?? MemoryCacheService();
  
  CacheService get cacheService => _cacheService;
  
  /// Limpa uma categoria específica de cache e notifica os ouvintes
  void invalidateCache({String? category}) {
    _cacheService.clear(category: category);
    notifyListeners();
  }
}

import 'dart:async';
import 'cache_service.dart';

class CacheEntry<T> {
  final T value;
  final DateTime? expiresAt;

  CacheEntry(this.value, {Duration? expiry})
      : expiresAt = expiry != null ? DateTime.now().add(expiry) : null;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

class MemoryCacheService implements CacheService {
  final Map<String, CacheEntry<dynamic>> _cache = {};
  
  @override
  bool has(String key) {
    if (!_cache.containsKey(key)) return false;
    
    final entry = _cache[key];
    if (entry != null && entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    
    return true;
  }

  @override
  T? get<T>(String key) {
    if (!has(key)) return null;
    return _cache[key]?.value as T?;
  }

  @override
  void set<T>(String key, T value, {Duration? expiry}) {
    _cache[key] = CacheEntry<T>(value, expiry: expiry);
  }

  @override
  void remove(String key) {
    _cache.remove(key);
  }

  @override
  void clear({String? category}) {
    if (category == null) {
      _cache.clear();
    } else {
      _cache.removeWhere((key, _) => key.startsWith('$category:'));
    }
  }

  @override
  Future<T> getOrFetch<T>(
    String key, 
    Future<T> Function() fetchFunction, 
    {Duration? expiry}
  ) async {
    if (has(key)) {
      return get<T>(key)!;
    }
    
    final value = await fetchFunction();
    set<T>(key, value, expiry: expiry);
    return value;
  }
  
  @override
  void updateIfExists<T>(String key, T value) {
    if (has(key)) {
      final existingEntry = _cache[key]!;
      _cache[key] = CacheEntry<T>(
        value, 
        expiry: existingEntry.expiresAt?.difference(DateTime.now())
      );
    }
  }
}

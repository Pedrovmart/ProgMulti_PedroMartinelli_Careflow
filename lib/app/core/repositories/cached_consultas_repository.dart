import 'package:careflow_app/app/core/repositories/base_repository.dart';
import 'package:careflow_app/app/core/repositories/n8n_consultas_repository.dart';
import 'package:careflow_app/app/core/services/cache/cache_service.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:flutter/foundation.dart';

/// Repositório de consultas com suporte a cache
class CachedConsultasRepository implements BaseRepository<ConsultaModel> {
  final N8nConsultasRepository _repository;
  final CacheService _cacheService;
  
  // Constantes para as chaves de cache
  static const String _cacheKeyAllConsultas = 'consultas:all';
  static const String _cacheKeyPacientePrefix = 'consultas:paciente:';
  static const String _cacheKeyProfissionalPrefix = 'consultas:profissional:';
  static const String _cacheKeyConsultaPrefix = 'consulta:';
  
  // Duração padrão do cache
  static const Duration _defaultCacheDuration = Duration(minutes: 5);
  
  CachedConsultasRepository(this._repository, this._cacheService);
  
  @override
  Future<List<ConsultaModel>> getAll() async {
    return _cacheService.getOrFetch<List<ConsultaModel>>(
      _cacheKeyAllConsultas,
      () => _repository.getAll(),
      expiry: _defaultCacheDuration,
    );
  }
  
  Future<List<ConsultaModel>> getByPacienteId(String pacienteId) async {
    final cacheKey = '$_cacheKeyPacientePrefix$pacienteId';
    return _cacheService.getOrFetch<List<ConsultaModel>>(
      cacheKey,
      () => _repository.getByPacienteId(pacienteId),
      expiry: _defaultCacheDuration,
    );
  }
  
  Future<List<ConsultaModel>> getByProfissionalId(String profissionalId) async {
    final cacheKey = '$_cacheKeyProfissionalPrefix$profissionalId';
    return _cacheService.getOrFetch<List<ConsultaModel>>(
      cacheKey,
      () => _repository.getByProfissionalId(profissionalId),
      expiry: _defaultCacheDuration,
    );
  }
  
  @override
  Future<ConsultaModel?> getById(String id) async {
    final cacheKey = '$_cacheKeyConsultaPrefix$id';
    return _cacheService.getOrFetch<ConsultaModel?>(
      cacheKey,
      () => _repository.getById(id),
      expiry: _defaultCacheDuration,
    );
  }
  
  @override
  Future<ConsultaModel> create(ConsultaModel item) async {
    final result = await _repository.create(item);
    _invalidateConsultasCache();
    return result;
  }
  
  @override
  Future<void> update(String id, ConsultaModel item) async {
    await _repository.update(id, item);
    _invalidateConsultasCache();
    
    // Atualiza o cache da consulta específica se existir
    final consultaCacheKey = '$_cacheKeyConsultaPrefix$id';
    _cacheService.updateIfExists(consultaCacheKey, item);
  }
  
  Future<void> updatePartialFields(String consultaId, Map<String, dynamic> fieldsToUpdate) async {
    await _repository.updatePartialFields(consultaId, fieldsToUpdate);
    _invalidateConsultasCache();
    
    // Se a consulta específica estiver em cache, precisamos atualizá-la ou removê-la
    final consultaCacheKey = '$_cacheKeyConsultaPrefix$consultaId';
    if (_cacheService.has(consultaCacheKey)) {
      _cacheService.remove(consultaCacheKey);
    }
  }
  
  Future<void> atualizarDiagnostico({
    required String idConsulta,
    required String diagnostico,
  }) async {
    await _repository.atualizarDiagnostico(
      idConsulta: idConsulta,
      diagnostico: diagnostico,
    );
    
    // Invalidar apenas o cache da consulta específica
    final consultaCacheKey = '$_cacheKeyConsultaPrefix$idConsulta';
    _cacheService.remove(consultaCacheKey);
  }
  
  @override
  Future<void> delete(String id) async {
    await _repository.delete(id);
    _invalidateConsultasCache();
    
    // Remove a consulta específica do cache
    final consultaCacheKey = '$_cacheKeyConsultaPrefix$id';
    _cacheService.remove(consultaCacheKey);
  }
  
  Future<void> cancelarConsulta(String consultaId) async {
    await _repository.cancelarConsulta(consultaId);
    _invalidateConsultasCache();
    
    // Remove a consulta específica do cache
    final consultaCacheKey = '$_cacheKeyConsultaPrefix$consultaId';
    _cacheService.remove(consultaCacheKey);
  }
  
  Future<String> agendarConsulta(ConsultaModel consulta) async {
    final consultaId = await _repository.agendarConsulta(consulta);
    _invalidateConsultasCache();
    return consultaId;
  }
  
  Future<ConsultaModel?> fetchConsultaById(String consultaId) async {
    final cacheKey = '$_cacheKeyConsultaPrefix$consultaId';
    return _cacheService.getOrFetch<ConsultaModel?>(
      cacheKey,
      () => _repository.fetchConsultaById(consultaId),
      expiry: _defaultCacheDuration,
    );
  }
  
  Future<Map<String, dynamic>> getDetalhesConsultaProfissionalPaciente({
    required String idProfissional,
    required String idPaciente,
  }) async {
    final cacheKey = 'detalhes:prof:$idProfissional:pac:$idPaciente';
    return _cacheService.getOrFetch<Map<String, dynamic>>(
      cacheKey,
      () => _repository.getDetalhesConsultaProfissionalPaciente(
        idProfissional: idProfissional,
        idPaciente: idPaciente,
      ),
      expiry: _defaultCacheDuration,
    );
  }
  
  /// Método para invalidar todo o cache de consultas
  void _invalidateConsultasCache() {
    _cacheService.remove(_cacheKeyAllConsultas);
    // Não podemos remover caches específicos de paciente/profissional
    // porque não sabemos quais IDs foram cacheados, então usamos clear com prefixo
    _cacheService.clear(category: 'consultas');
  }
  
  /// Método para pré-carregar dados em cache (útil para dados frequentemente acessados)
  Future<void> preloadConsultasData(String profissionalId) async {
    try {
      debugPrint('Pré-carregando dados de consultas para o profissional $profissionalId');
      await getByProfissionalId(profissionalId);
    } catch (e) {
      debugPrint('Erro ao pré-carregar dados: $e');
    }
  }
}

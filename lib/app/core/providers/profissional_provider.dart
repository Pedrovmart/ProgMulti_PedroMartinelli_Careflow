import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/core/repositories/n8n_profissional_repository.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';

class ProfissionalProvider extends ChangeNotifier {
  // Repositório n8n para operações CRUD
  late final N8nProfissionalRepository _n8nRepository;
  
  ProfissionalProvider() {
    final n8nClient = N8nHttpClient();
    _n8nRepository = N8nProfissionalRepository(n8nClient);
  }

  List<Profissional> _profissionais = [];

  List<Profissional> get profissionais => _profissionais;

  Future<void> fetchProfissionais() async {
    try {
      // Busca os profissionais do n8n
      _profissionais = await _n8nRepository.getAll();

      // Notifica os ouvintes sobre a mudança
      notifyListeners();
    } catch (e) {
      // Lança uma exceção com a mensagem de erro
      throw Exception("Erro ao buscar profissionais: ${e.toString()}");
    }
  }

  // O método addProfissional não é mais necessário aqui
  // A criação de profissionais é feita pelo AuthRepository
  // Este método pode ser usado para sincronização se necessário
  Future<void> syncProfissional(Profissional profissional) async {
    try {
      // Verifica se o profissional já existe no n8n
      final profissionalExistente = await _n8nRepository.getById(profissional.id);
      
      if (profissionalExistente == null) {
        // Se não existir, cria um novo
        await _n8nRepository.create(profissional);
      } else {
        // Se existir, atualiza
        await _n8nRepository.update(profissional.id, profissional);
      }
      
      // Atualiza a lista local
      await fetchProfissionais();
    } catch (e) {
      debugPrint('Erro ao sincronizar profissional com n8n: $e');
      // Não lança exceção para não interromper o fluxo principal
    }
  }

  Future<void> removeProfissional(String id) async {
    try {
      // Remove do n8n
      await _n8nRepository.delete(id);
      
      // Atualiza a lista local
      _profissionais = _profissionais.where((p) => p.id != id).toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao remover profissional: ${e.toString()}");
    }
  }

  Future<void> updateProfissional(Profissional updatedProfissional) async {
    try {
      // Atualiza no n8n
      await _n8nRepository.update(updatedProfissional.id, updatedProfissional);
      
      // Atualiza a lista local
      _profissionais = _profissionais
          .map((p) => p.id == updatedProfissional.id ? updatedProfissional : p)
          .toList();
          
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao atualizar profissional: ${e.toString()}");
    }
  }

  Future<Profissional?> getProfissionalById(String id) async {
    try {
      return await _n8nRepository.getById(id);
    } catch (e) {
      throw Exception("Erro ao buscar profissional por ID: ${e.toString()}");
    }
  }
  
  // Método para buscar profissionais por especialidade
  Future<List<Profissional>> getProfissionaisByEspecialidade(String especialidade) async {
    try {
      return await _n8nRepository.getByEspecialidade(especialidade);
    } catch (e) {
      throw Exception("Erro ao buscar profissionais por especialidade: ${e.toString()}");
    }
  }
  
  // Método para buscar profissionais por empresa
  Future<List<Profissional>> getProfissionaisByEmpresa(String empresaId) async {
    try {
      return await _n8nRepository.getByEmpresa(empresaId);
    } catch (e) {
      throw Exception("Erro ao buscar profissionais por empresa: ${e.toString()}");
    }
  }
}

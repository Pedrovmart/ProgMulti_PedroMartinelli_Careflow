import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/core/repositories/n8n_profissional_repository.dart';
import 'package:careflow_app/app/core/http/n8n_http_client.dart';

class ProfissionalProvider extends ChangeNotifier {
  late final N8nProfissionalRepository _n8nRepository;
  final N8nHttpClient _n8nClient;

  ProfissionalProvider() : _n8nClient = N8nHttpClient() {
    _n8nRepository = N8nProfissionalRepository(_n8nClient);
  }

  List<Profissional> _profissionais = [];
  List<String> _especialidades = [];
  bool _isLoadingEspecialidades = false;
  String? _especialidadesError;

  List<Profissional> get profissionais => _profissionais;
  List<String> get especialidades => _especialidades;
  bool get isLoadingEspecialidades => _isLoadingEspecialidades;
  String? get especialidadesError => _especialidadesError;

  Future<void> fetchProfissionais() async {
    try {
      _profissionais = await _n8nRepository.getAll();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao buscar profissionais: ${e.toString()}");
    }
  }


  Future<void> syncProfissional(Profissional profissional) async {
    try {
      final profissionalExistente = await _n8nRepository.getById(
        profissional.id,
      );

      if (profissionalExistente == null) {
        await _n8nRepository.create(profissional);
      } else {
        await _n8nRepository.update(profissional.id, profissional);
      }

      await fetchProfissionais();
    } catch (e) {
      debugPrint('Erro ao sincronizar profissional com n8n: $e');
    }
  }

  Future<void> removeProfissional(String id) async {
    try {
      await _n8nRepository.delete(id);

      _profissionais = _profissionais.where((p) => p.id != id).toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao remover profissional: ${e.toString()}");
    }
  }

  Future<void> updateProfissional(Profissional updatedProfissional) async {
    try {
      await _n8nRepository.update(updatedProfissional.id, updatedProfissional);

      _profissionais =
          _profissionais
              .map(
                (p) => p.id == updatedProfissional.id ? updatedProfissional : p,
              )
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


  String? _currentProfileImage;

  String? get currentProfileImage => _currentProfileImage;

  Future<String?> uploadProfileImage(
    String profissionalId,
    File imageFile,
  ) async {
    try {
      final imageUrl = await _n8nRepository.uploadProfileImage(
        profissionalId,
        imageFile,
      );

      _currentProfileImage = imageUrl; 
      notifyListeners();

      final index = _profissionais.indexWhere((p) => p.id == profissionalId);
      if (index != -1) {
        final profissional = _profissionais[index];
        final updatedProfissional = Profissional(
          id: profissional.id,
          nome: profissional.nome,
          email: profissional.email,
          especialidade: profissional.especialidade,
          numeroRegistro: profissional.numeroRegistro,
          dataNascimento: profissional.dataNascimento,
          telefone: profissional.telefone,
          profileUrlImage: imageUrl,
        );
        _profissionais[index] = updatedProfissional;
      }

      return imageUrl;
    } catch (e) {
      log('Erro ao fazer upload da imagem de perfil: $e');
      rethrow;
    }
  }

  Future<String?> getProfileImageUrl(String profissionalId) async {
    try {
      return await _n8nRepository.getProfileImageUrl(profissionalId);
    } catch (e) {
      log('Erro ao obter URL da imagem de perfil: $e');
      return null;
    }
  }

  updateFields(String userId, Map<String, dynamic> updateFields) {}

  Future<void> update(String id, Profissional profissional) async {
    try {
      await _n8nRepository.update(id, profissional);
      await getProfissionalById(id); 
      notifyListeners();
    } catch (e) {
      log('Erro ao atualizar profissional: $e');
      rethrow;
    }
  }
  
  Future<List<String>> fetchEspecialidades() async {
    try {
      _isLoadingEspecialidades = true;
      _especialidadesError = null;
      notifyListeners();
      
      _especialidades = await _n8nRepository.getEspecialidades();
      
      _isLoadingEspecialidades = false;
      notifyListeners();
      return _especialidades;
    } catch (e) {
      _isLoadingEspecialidades = false;
      _especialidadesError = "Erro ao buscar especialidades: ${e.toString()}";
      notifyListeners();
      
      throw Exception(_especialidadesError);
    }
  }

}

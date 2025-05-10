import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/core/repositories/profissional_repository.dart';

class ProfissionalProvider extends ChangeNotifier {
  final ProfissionalRepository _profissionalRepository =
      ProfissionalRepository();

  List<Profissional> _profissionais = [];

  List<Profissional> get profissionais => _profissionais;

  Future<void> fetchProfissionais() async {
    try {
      // Busca os profissionais do repositório
      final profissionaisMap =
          await _profissionalRepository.getAllProfissionais();

      // Converte o Map<String, Map<String, dynamic>> para List<Profissional>
      _profissionais =
          profissionaisMap.entries.map((entry) {
            final id = entry.key;
            final data = entry.value;
            return Profissional.fromJson({
              ...data,
              'id': id, // Adiciona o ID do documento ao JSON
            });
          }).toList();

      // Notifica os ouvintes sobre a mudança
      notifyListeners();
    } catch (e) {
      // Lança uma exceção com a mensagem de erro
      throw Exception("Erro ao buscar profissionais: ${e.toString()}");
    }
  }

  Future<void> addProfissional(Profissional profissional) async {
    try {
      await _profissionalRepository.addProfissional(profissional);
      _profissionais.add(profissional);
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao adicionar profissional: ${e.toString()}");
    }
  }

  Future<void> removeProfissional(String id) async {
    try {
      await _profissionalRepository.deleteProfissional(id);
      _profissionais =
          _profissionais
              .where((profissional) => profissional.id != id)
              .toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao remover profissional: ${e.toString()}");
    }
  }

  Future<void> updateProfissional(Profissional updatedProfissional) async {
    try {
      await _profissionalRepository.updateProfissional(updatedProfissional);
      _profissionais =
          _profissionais.map((profissional) {
            return profissional.id == updatedProfissional.id
                ? updatedProfissional
                : profissional;
          }).toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao atualizar profissional: ${e.toString()}");
    }
  }

  Future<Profissional?> getProfissionalById(String id) async {
    try {
      return await _profissionalRepository.getProfissionalById(id);
    } catch (e) {
      throw Exception("Erro ao buscar profissional por ID: ${e.toString()}");
    }
  }
}

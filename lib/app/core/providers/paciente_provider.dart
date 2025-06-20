import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:careflow_app/app/core/repositories/n8n_paciente_repository.dart';
import 'package:careflow_app/app/core/repositories/repository_manager.dart';

class PacienteProvider extends ChangeNotifier {
  final N8nPacienteRepository _pacienteRepository;

  PacienteProvider()
    : _pacienteRepository = RepositoryManager().getPacienteRepository();

  List<Paciente> _pacientes = [];

  List<Paciente> get pacientes => _pacientes;

  Future<void> fetchPacientes() async {
    try {
      _pacientes = await _pacienteRepository.getAll();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao buscar pacientes: ${e.toString()}");
    }
  }

  Future<void> addPaciente(Paciente paciente) async {
    try {
      final novoPaciente = await _pacienteRepository.create(paciente);
      _pacientes.add(novoPaciente);
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao adicionar paciente: ${e.toString()}");
    }
  }

  Future<void> removePaciente(String id) async {
    try {
      await _pacienteRepository.delete(id);
      _pacientes = _pacientes.where((paciente) => paciente.id != id).toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao remover paciente: ${e.toString()}");
    }
  }

  Future<void> updatePaciente(Paciente updatedPaciente) async {
    try {
      await _pacienteRepository.update(updatedPaciente.id, updatedPaciente);
      _pacientes =
          _pacientes
              .map(
                (paciente) =>
                    paciente.id == updatedPaciente.id
                        ? updatedPaciente
                        : paciente,
              )
              .toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao atualizar paciente: ${e.toString()}");
    }
  }

  Future<Paciente?> getPacienteById(String id) async {
    try {
      return await _pacienteRepository.getById(id);
    } catch (e) {
      throw Exception("Erro ao buscar paciente por ID: ${e.toString()}");
    }
  }

  String? _currentProfileImage;

  String? get currentProfileImage => _currentProfileImage;

  Future<String?> uploadProfileImage(String pacienteId, File imageFile) async {
    try {
      final imageUrl = await _pacienteRepository.uploadProfileImage(
        pacienteId,
        imageFile,
      );

      _currentProfileImage = imageUrl;
      notifyListeners();

      final index = _pacientes.indexWhere((p) => p.id == pacienteId);
      if (index != -1) {
        final paciente = _pacientes[index];
        final updatedPaciente = paciente.copyWith(profileUrlImage: imageUrl);
        _pacientes[index] = updatedPaciente;
      }

      return imageUrl;
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem de perfil: $e');
      rethrow;
    }
  }

  Future<String?> getProfileImageUrl(String pacienteId) async {
    try {
      final imageUrl = await _pacienteRepository.getProfileImageUrl(pacienteId);
      if (imageUrl != null) {
        _currentProfileImage = imageUrl;
        notifyListeners();
      }
      return imageUrl;
    } catch (e) {
      debugPrint('Erro ao obter URL da imagem: $e');
      return null;
    }
  }

  Future<void> update(String id, Paciente paciente) async {
    try {
      await _pacienteRepository.update(id, paciente);
      await getPacienteById(id); 
      notifyListeners();
    } catch (e) {
      log('Erro ao atualizar paciente: $e');
      rethrow;
    }
  }
}

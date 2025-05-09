import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:careflow_app/app/core/repositories/paciente_repository.dart';

class PacienteProvider extends ChangeNotifier {
  final PacienteRepository _pacienteRepository = PacienteRepository();

  List<Paciente> _pacientes = [];

  List<Paciente> get pacientes => _pacientes;

  Future<void> fetchPacientes() async {
    try {
      _pacientes = await _pacienteRepository.getAllPacientes();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao buscar pacientes: ${e.toString()}");
    }
  }

  Future<void> addPaciente(Paciente paciente) async {
    try {
      await _pacienteRepository.addPaciente(paciente);
      _pacientes.add(paciente);
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao adicionar paciente: ${e.toString()}");
    }
  }

  Future<void> removePaciente(String id) async {
    try {
      await _pacienteRepository.deletePaciente(id);
      _pacientes = _pacientes.where((paciente) => paciente.id != id).toList();
      notifyListeners();
    } catch (e) {
      throw Exception("Erro ao remover paciente: ${e.toString()}");
    }
  }

  Future<void> updatePaciente(Paciente updatedPaciente) async {
    try {
      await _pacienteRepository.updatePaciente(updatedPaciente);
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
      return await _pacienteRepository.getPacienteById(id);
    } catch (e) {
      throw Exception("Erro ao buscar paciente por ID: ${e.toString()}");
    }
  }
}

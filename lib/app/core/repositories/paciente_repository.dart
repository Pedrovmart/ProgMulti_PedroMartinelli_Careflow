import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referência para a coleção de pacientes no Firestore
  CollectionReference get _pacientesCollection => _firestore
      .collection('usuarios')
      .doc('pacientes')
      .collection('pacientes');

  // Fetch all patients
  Future<List<Paciente>> getAllPacientes() async {
    try {
      final querySnapshot = await _pacientesCollection.get();
      return querySnapshot.docs
          .map(
            (doc) => Paciente.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception("Erro ao buscar pacientes: ${e.toString()}");
    }
  }

  // Fetch a patient by ID
  Future<Paciente?> getPacienteById(String id) async {
    try {
      final docSnapshot = await _pacientesCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Paciente.fromJson({
          ...docSnapshot.data() as Map<String, dynamic>,
          'id': docSnapshot.id,
        });
      }
      return null;
    } catch (e) {
      throw Exception("Erro ao buscar paciente por ID: ${e.toString()}");
    }
  }

  // Add a new patient
  Future<void> addPaciente(Paciente paciente) async {
    try {
      await _pacientesCollection.add(paciente.toJson());
    } catch (e) {
      throw Exception("Erro ao adicionar paciente: ${e.toString()}");
    }
  }

  // Update an existing patient
  Future<void> updatePaciente(Paciente paciente) async {
    try {
      await _pacientesCollection.doc(paciente.id).update(paciente.toJson());
    } catch (e) {
      throw Exception("Erro ao atualizar paciente: ${e.toString()}");
    }
  }

  // Delete a patient by ID
  Future<void> deletePaciente(String id) async {
    try {
      await _pacientesCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Erro ao remover paciente: ${e.toString()}");
    }
  }
}

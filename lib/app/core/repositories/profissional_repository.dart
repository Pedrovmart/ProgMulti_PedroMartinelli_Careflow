import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfissionalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referência para a coleção de profissionais no Firestore
  CollectionReference get _profissionaisCollection => _firestore
      .collection('usuarios')
      .doc('profissionais')
      .collection('profissionais');

  // Método para buscar todos os profissionais
  Future<List<Profissional>> getAllProfissionais() async {
    try {
      final querySnapshot = await _profissionaisCollection.get();
      return querySnapshot.docs
          .map(
            (doc) => Profissional.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception("Erro ao buscar profissionais: ${e.toString()}");
    }
  }

  // Método para buscar um profissional por ID
  Future<Profissional?> getProfissionalById(String id) async {
    try {
      final docSnapshot = await _profissionaisCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Profissional.fromJson({
          ...docSnapshot.data() as Map<String, dynamic>,
          'id': docSnapshot.id,
        });
      }
      return null;
    } catch (e) {
      throw Exception("Erro ao buscar profissional por ID: ${e.toString()}");
    }
  }

  // Método para adicionar um profissional
  Future<void> addProfissional(Profissional profissional) async {
    try {
      await _profissionaisCollection.add(profissional.toJson());
    } catch (e) {
      throw Exception("Erro ao adicionar profissional: ${e.toString()}");
    }
  }

  // Método para atualizar um profissional
  Future<void> updateProfissional(Profissional profissional) async {
    try {
      await _profissionaisCollection
          .doc(profissional.id)
          .update(profissional.toJson());
    } catch (e) {
      throw Exception("Erro ao atualizar profissional: ${e.toString()}");
    }
  }

  // Método para remover um profissional
  Future<void> deleteProfissional(String id) async {
    try {
      await _profissionaisCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Erro ao remover profissional: ${e.toString()}");
    }
  }
}

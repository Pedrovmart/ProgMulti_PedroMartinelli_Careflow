import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class ConsultasRepository {
  final FirebaseFirestore _firestore;

  ConsultasRepository(this._firestore);

  // Busca todas as consultas agendadas
  Future<List<ConsultaModel>> fetchConsultasAgendadas() async {
    try {
      final querySnapshot = await _firestore.collection('consultas').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ConsultaModel.fromMap({
          'id': doc.id, // Adiciona o ID do documento
          ...data,
        });
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar consultas agendadas: $e');
    }
  }

  // Agenda uma nova consulta
  Future<void> agendarConsulta(ConsultaModel consulta) async {
    try {
      await _firestore.collection('consultas').add(consulta.toMap());
    } catch (e) {
      throw Exception('Erro ao agendar consulta: $e');
    }
  }

  // Cancela uma consulta pelo ID
  Future<void> cancelarConsulta(String consultaId) async {
    try {
      await _firestore.collection('consultas').doc(consultaId).delete();
    } catch (e) {
      throw Exception('Erro ao cancelar consulta: $e');
    }
  }

  // Busca uma consulta específica pelo ID
  Future<ConsultaModel?> fetchConsultaById(String consultaId) async {
    try {
      final docSnapshot =
          await _firestore.collection('consultas').doc(consultaId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return ConsultaModel.fromMap({
          'id': docSnapshot.id, // Adiciona o ID do documento
          ...data,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar consulta pelo ID: $e');
    }
  }
}

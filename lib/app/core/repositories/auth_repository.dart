import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Autenticação do usuário
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw Exception("Falha ao fazer login: ${e.toString()}");
    }
  }

  // Método de cadastro para Paciente
  Future<User?> registerPaciente(
    String email,
    String password,
    String name,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc('pacientes')
          .collection('pacientes')
          .doc(userCredential.user!.uid)
          .set({
            'nome': name,
            'email': email,
            'userType': 'paciente',
            'createdAt': FieldValue.serverTimestamp(),
          });
      return userCredential.user;
    } catch (e) {
      throw Exception("Falha ao registrar paciente: ${e.toString()}");
    }
  }

  // Método de cadastro para Profissional
  Future<User?> registerProfissional(
    String email,
    String password,
    String name,
    String especialidade,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc('profissionais')
          .collection('profissionais')
          .doc(userCredential.user!.uid)
          .set({
            'nome': name,
            'email': email,
            'especialidade': especialidade,
            'userType': 'profissional',
            'createdAt': FieldValue.serverTimestamp(),
          });
      return userCredential.user;
    } catch (e) {
      throw Exception("Falha ao registrar profissional: ${e.toString()}");
    }
  }

  // Método para obter o tipo de usuário
  Future<String> getUserType(String uid) async {
    try {
      final pacienteDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc('pacientes')
              .collection('pacientes')
              .doc(uid)
              .get();
      if (pacienteDoc.exists) return 'paciente';

      final profissionalDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc('profissionais')
              .collection('profissionais')
              .doc(uid)
              .get();
      if (profissionalDoc.exists) return 'profissional';

      throw Exception('Usuário não encontrado.');
    } catch (e) {
      throw Exception("Erro ao verificar tipo de usuário: ${e.toString()}");
    }
  }

  // Método de logout
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Falha ao sair: ${e.toString()}");
    }
  }

  User? getCurrentUser() {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception("Erro ao obter o usuário atual: ${e.toString()}");
    }
  }

  // Stream de estado de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}

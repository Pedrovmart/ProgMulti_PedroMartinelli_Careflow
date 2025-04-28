import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método de login
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

      // Atualiza o nome do paciente no Firebase Auth
      await userCredential.user?.updateDisplayName(name);

      // Salva o paciente no Firestore
      final userRef = userCredential.user?.uid;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc('pacientes')
          .collection('pacientes')
          .doc(userRef)
          .set({
            'nome': name,
            'email': email,
            'dataNascimento': null,
            'telefone': null,
            'endereco': null,
            'cpf': null,
            'sexo': null,
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
    String numRegistro,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      final userRef = userCredential.user?.uid;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc('profissionais')
          .collection('profissionais')
          .doc(userRef)
          .set({
            'nome': name,
            'email': email,
            'especialidade': especialidade,
            'numRegistro': numRegistro,
            'createdAt': FieldValue.serverTimestamp(),
          });

      return userCredential.user;
    } catch (e) {
      throw Exception("Falha ao registrar profissional: ${e.toString()}");
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
}

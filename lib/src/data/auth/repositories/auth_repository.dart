import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

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
            'userType': 'paciente',
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

      if (userCredential.user == null) {
        throw Exception("Erro ao criar o usuário no FirebaseAuth");
      }

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
            'userType': 'profissional',
            'dataNascimento': null,
            'telefone': null,
            'createdAt': FieldValue.serverTimestamp(),
          });

      return userCredential.user;
    } catch (e) {
      throw Exception("Falha ao registrar profissional: ${e.toString()}");
    }
  }

  Future<String> getUserType(String uid) async {
    try {
      final pacienteDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc('pacientes')
              .collection('pacientes')
              .doc(uid)
              .get();

      if (pacienteDoc.exists) {
        return pacienteDoc['userType'];
      }

      final profissionalDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc('profissionais')
              .collection('profissionais')
              .doc(uid)
              .get();

      if (profissionalDoc.exists) {
        return profissionalDoc['userType'];
      }

      throw Exception('Usuário não encontrado nas coleções.');
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
}

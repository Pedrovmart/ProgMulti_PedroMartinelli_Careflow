import 'dart:developer'; // Adicionado para log
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService();
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


  Future<User?> registerProfissional(
    String email,
    String password,
    String name,
    String especialidade,
    String numRegistro, 
  ) async {
    try {
      await _supabaseService.initialize();
      
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      
      final uid = userCredential.user!.uid;
      
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc('profissionais')
          .collection('profissionais')
          .doc(uid)
          .set({
            'nome': name,
            'email': email,
            'especialidade': especialidade,
            'numRegistro': numRegistro,
            'userType': 'profissional',
            'createdAt': FieldValue.serverTimestamp(),
          });
      
      await _supabaseService.insertProfissional(
        nome: name,
        email: email,
        especialidade: especialidade,
        numRegistro: numRegistro,
        firebaseUid: uid,
      );
      
      return userCredential.user;
    } catch (e) {
      log('Erro ao registrar profissional: ${e.toString()}');
      throw Exception("Falha ao registrar profissional: ${e.toString()}");
    }
  }

  Future<String> getUserType(String uid) async {
    log('AuthRepository: Iniciando getUserType para UID: $uid');
    try {
      log('AuthRepository: Tentando buscar documento do paciente...');
      final pacienteDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc('pacientes')
              .collection('pacientes')
              .doc(uid)
              .get();
      log('AuthRepository: Documento do paciente buscado. Existe: ${pacienteDoc.exists}');
      if (pacienteDoc.exists) {
        log('AuthRepository: Usuário é paciente.');
        return 'paciente';
      }

      log('AuthRepository: Tentando buscar documento do profissional...');
      final profissionalDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc('profissionais')
              .collection('profissionais')
              .doc(uid)
              .get();
      log('AuthRepository: Documento do profissional buscado. Existe: ${profissionalDoc.exists}');
      if (profissionalDoc.exists) {
        log('AuthRepository: Usuário é profissional.');
        return 'profissional';
      }

      log('AuthRepository: Usuário não encontrado em nenhuma coleção.');
      throw Exception('Usuário não encontrado.');
    } catch (e) {
      log('AuthRepository: Erro em getUserType: ${e.toString()}');
      throw Exception("Erro ao verificar tipo de usuário: ${e.toString()}");
    }
  }

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

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}

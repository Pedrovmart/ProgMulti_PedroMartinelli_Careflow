import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _initialized = false;
  static late final SupabaseClient _client;
  
  static Future<void> initializeGlobally() async {
    if (_initialized) return;
    
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('Supabase environment variables not found');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true,
      );
      
      _client = Supabase.instance.client;
      _initialized = true;
      log('Supabase inicializado com sucesso');
    } catch (e) {
      log('Erro ao inicializar Supabase: $e');
      rethrow;
    }
  }
  
  Future<void> initialize() async {
    if (!_initialized) {
      await initializeGlobally();
    }
  }

  Future<void> insertProfissional({
    required String nome,
    required String email,
    required String especialidade,
    required String numRegistro,
    required String firebaseUid,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      log('Inserindo profissional no Supabase: $nome, $email');
      final response = await _client.from('profissionais').insert({
        'nome': nome,
        'email': email,
        'especialidade': especialidade,
        'num_registro': numRegistro,
        'firebase_uid': firebaseUid,
      }).select();
      log('Profissional inserido com sucesso no Supabase: $response');
    } catch (e) {
      log('Erro ao inserir profissional no Supabase: $e');
      throw Exception('Falha ao inserir profissional no Supabase: ${e.toString()}');
    }
  }
}

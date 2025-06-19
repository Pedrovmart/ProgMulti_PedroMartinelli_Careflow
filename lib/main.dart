import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'app/app.dart';
import 'app/core/dependency_injection.dart';
import 'app/core/ui/app_theme.dart';
import 'app/core/services/supabase_service.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kDebugMode) {
      debugPrint('Erro do Flutter: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    }
  };
  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      debugPrint('Iniciando inicialização do aplicativo...');
      await dotenv.load(fileName: ".env");
      debugPrint('Variáveis de ambiente carregadas com sucesso');
      await Firebase.initializeApp();
      debugPrint('Firebase inicializado com sucesso');
      await SupabaseService.initializeGlobally();
      debugPrint('Supabase inicializado com sucesso');
      await DependencyInjection.init();
      debugPrint('Injeção de dependências inicializada');
      runApp(App(theme: AppTheme.themeData));
    } catch (e, stackTrace) {
      debugPrint('ERRO CRÍTICO durante a inicialização:');
      debugPrint('Erro: $e');
      debugPrint('Stack trace: $stackTrace');
      runApp(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Ocorreu um erro inesperado',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => main(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  runZonedGuarded<Future<void>>(() => initializeApp(), (error, stackTrace) {
    debugPrint('ERRO NÃO TRATADO:');
    debugPrint('Erro: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}

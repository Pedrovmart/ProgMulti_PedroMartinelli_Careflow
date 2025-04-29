import 'package:careflow_app/src/data/auth/repositories/auth_repository.dart';
import 'package:careflow_app/src/data/auth/usecases/auth_usecase.dart';
import 'package:careflow_app/src/presentation/pages/login_page.dart';
import 'package:careflow_app/src/presentation/pages/paciente_main_page.dart';
import 'package:careflow_app/src/presentation/pages/profissional_main_page.dart';
import 'package:careflow_app/src/presentation/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => AuthUseCase(AuthRepository())),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(AuthUseCase(AuthRepository())),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return StreamBuilder<firebase_auth.User?>(
            stream: authProvider.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Espera enquanto o estado é carregado
              }

              if (snapshot.hasData) {
                if (authProvider.userType == 'paciente') {
                  return PacienteMainPage(); // Página do paciente
                } else if (authProvider.userType == 'profissional') {
                  return ProfissionalMainPage(); // Página do profissional
                }
              }

              return LoginPage();
            },
          );
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

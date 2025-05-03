import 'package:flutter/material.dart';
import 'package:careflow_app/app/routes/routes.dart'; // Suas rotas personalizadas
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:careflow_app/app/features/auth/login/login_page.dart';
import 'package:careflow_app/app/features/paciente/paciente_main_page.dart';
import 'package:careflow_app/app/features/profissional/profissional_main_page.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'CareFlow',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: Routes.generateRoute,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return StreamBuilder<User?>(
              stream: authProvider.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Aguarda a verificação do login
                }

                if (snapshot.hasData) {
                  // Se o usuário estiver logado, define para qual página irá
                  if (authProvider.userType == 'paciente') {
                    return PacienteMainPage(); // Direciona para a home do paciente
                  } else if (authProvider.userType == 'profissional') {
                    return ProfissionalMainPage(); // Direciona para a home do profissional
                  }
                }

                // Se o usuário não estiver autenticado, mostra a tela de login
                return LoginPage();
              },
            );
          },
        ),
      ),
    );
  }
}

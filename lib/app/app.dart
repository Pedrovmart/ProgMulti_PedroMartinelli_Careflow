import 'package:careflow_app/app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show User; // Alias para evitar conflito de importação
import 'package:flutter/material.dart';
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
      create: (_) => AuthProvider(), // Provedor para gerenciar a autenticação
      child: MaterialApp(
        title: 'CareFlow',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: Routes.login, // Rota inicial
        onGenerateRoute: Routes.generateRoute, // Usando o gerador de rotas
        home: Consumer<AuthProvider>(
          // Consumindo o AuthProvider para a verificação de autenticação
          builder: (context, authProvider, _) {
            return StreamBuilder<User?>(
              // Escutando as mudanças de estado de autenticação
              stream:
                  authProvider
                      .authStateChanges, // Fluxo que retorna o estado de autenticação do Firebase
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Exibe um carregando enquanto verifica o estado
                }

                if (snapshot.hasData) {
                  // Verifica o tipo de usuário e redireciona para a página apropriada
                  if (authProvider.userType == 'paciente') {
                    return PacienteMainPage(); // Página do paciente
                  } else if (authProvider.userType == 'profissional') {
                    return ProfissionalMainPage(); // Página do profissional
                  }
                }

                return LoginPage(); // Usuário não autenticado, exibe a página de login
              },
            );
          },
        ),
      ),
    );
  }
}

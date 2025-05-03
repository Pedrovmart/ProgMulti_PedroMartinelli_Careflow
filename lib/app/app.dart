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
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'CareFlow',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: Routes.login,
        onGenerateRoute: Routes.generateRoute,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return StreamBuilder<User?>(
              stream: authProvider.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  if (authProvider.userType == 'paciente') {
                    return PacienteMainPage();
                  } else if (authProvider.userType == 'profissional') {
                    return ProfissionalMainPage();
                  }
                }

                return LoginPage();
              },
            );
          },
        ),
      ),
    );
  }
}

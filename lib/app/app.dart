import 'package:careflow_app/app/features/perfil/perfil_controller.dart';
import 'package:careflow_app/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/repositories/n8n_profissional_repository.dart';
import 'package:careflow_app/app/core/dependency_injection.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final ThemeData? theme;
  const App({super.key, this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfissionalProvider()),
        ChangeNotifierProvider(create: (_) => PacienteProvider()),
        ChangeNotifierProvider(create: (_) => ConsultasProvider()),
        Provider<N8nProfissionalRepository>(create: (_) => DependencyInjection.profissionalRepository), // Added N8nProfissionalRepository
        ChangeNotifierProxyProvider3<
          AuthProvider,
          PacienteProvider,
          ProfissionalProvider,
          PerfilController
        >(
          create:
              (context) => PerfilController(
                context.read<AuthProvider>(),
                context.read<PacienteProvider>(),
                context.read<ProfissionalProvider>(),
              ),
          update:
              (context, auth, paciente, profissional, previous) =>
                  PerfilController(auth, paciente, profissional),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'CareFlow',
            debugShowCheckedModeBanner: false,
            theme: theme,
            routerConfig: Routes.createRouter(authProvider: authProvider),
          );
        },
      ),
    );
  }
}

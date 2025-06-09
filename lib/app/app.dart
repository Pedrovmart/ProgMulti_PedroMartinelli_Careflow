import 'package:careflow_app/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:provider/provider.dart';

import 'features/perfil/perfil_controller.dart';

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
        ChangeNotifierProvider(
          create:
              (context) => PerfilController(
                Provider.of<AuthProvider>(context, listen: false),
                Provider.of<PacienteProvider>(context, listen: false),
                Provider.of<ProfissionalProvider>(context, listen: false),
              ),
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

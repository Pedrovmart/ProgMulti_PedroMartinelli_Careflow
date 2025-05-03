import 'package:careflow_app/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'CareFlow',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            routerConfig: Routes.createRouter(authProvider: authProvider),
          );
        },
      ),
    );
  }
}

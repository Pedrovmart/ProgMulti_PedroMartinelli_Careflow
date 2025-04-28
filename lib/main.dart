import 'package:careflow_app/src/data/auth/repositories/auth_repository.dart';
import 'package:careflow_app/src/data/auth/usecases/auth_usecase.dart';
import 'package:careflow_app/src/presentation/pages/login_page.dart';
import 'package:careflow_app/src/presentation/pages/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/src/presentation/pages/home_page.dart';

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
      title: 'CareFlow App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

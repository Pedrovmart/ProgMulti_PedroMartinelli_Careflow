import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/src/presentation/providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isProfisssional =
      false; // Controla se o tipo é "Profissional" ou "Paciente"

  final TextEditingController _especialidadeController =
      TextEditingController();
  final TextEditingController _numRegistroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: _isProfisssional,
                  onChanged: (bool? value) {
                    setState(() {
                      _isProfisssional = value!;
                    });
                  },
                ),
                Text('Paciente'),
                Radio<bool>(
                  value: true,
                  groupValue: _isProfisssional,
                  onChanged: (bool? value) {
                    setState(() {
                      _isProfisssional = value!;
                    });
                  },
                ),
                Text('Profissional'),
              ],
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            if (_isProfisssional) ...[
              TextField(
                controller: _especialidadeController,
                decoration: InputDecoration(labelText: 'Especialidade'),
              ),
              TextField(
                controller: _numRegistroController,
                decoration: InputDecoration(labelText: 'Número de Registro'),
              ),
            ],
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_isProfisssional) {
                  await context.read<AuthProvider>().signUp(
                    email: _emailController.text,
                    password: _passwordController.text,
                    name: _nameController.text,
                    userType: 'profissional',
                    especialidade: _especialidadeController.text,
                    numRegistro: _numRegistroController.text,
                  );
                } else {
                  await context.read<AuthProvider>().signUp(
                    email: _emailController.text,
                    password: _passwordController.text,
                    name: _nameController.text,
                    userType: 'paciente',
                  );
                }

                if (context.mounted) {
                  if (context.read<AuthProvider>().isAuthenticated) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Cadastro falhou')));
                  }
                }
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

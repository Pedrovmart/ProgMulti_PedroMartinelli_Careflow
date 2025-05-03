import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light, // Fundo claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    'Bem-vindo ao CareFlow',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de Senha
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // Botão de Login ou Indicador de Carregamento
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryDark,
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await context.read<AuthProvider>().login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          if (context.mounted &&
                              context.read<AuthProvider>().isAuthenticated) {
                            final userType =
                                context.read<AuthProvider>().userType;

                            // Verifica o tipo de usuário e navega para a página correspondente
                            if (userType == 'paciente') {
                              context.go('/homePaciente');
                            } else if (userType == 'profissional') {
                              context.go('/homeProfissional');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tipo de usuário desconhecido'),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login falhou')),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao fazer login'),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Botão de Cadastro
                  TextButton(
                    onPressed: () {
                      context.push('/signup');
                    },
                    child: Text(
                      'Não tem uma conta? Cadastre-se',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

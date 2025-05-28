import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const String route = '/signup';

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _numRegistroController = TextEditingController();

  bool _isLoading = false;
  bool _isProfissional = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
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
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle para selecionar Paciente ou Profissional
                  Center(
                    child: ToggleButtons(
                      isSelected: [_isProfissional == false, _isProfissional],
                      onPressed: (index) {
                        setState(() {
                          _isProfissional = index == 1;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      fillColor: AppColors.primaryDark,
                      color: AppColors.primary,
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 120,
                      ),
                      children: const [Text('Paciente'), Text('Profissional')],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de Nome
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primaryDark),
                      ),
                      prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    ),
                    cursorColor: AppColors.primaryDark,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primaryDark),
                      ),
                      prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    ),
                    cursorColor: AppColors.primaryDark,
                  ),
                  const SizedBox(height: 16),

                  // Campos adicionais para Profissional
                  if (_isProfissional) ...[
                    TextField(
                      controller: _especialidadeController,
                      decoration: InputDecoration(
                        labelText: 'Especialidade',
                        labelStyle: TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryDark),
                        ),
                        prefixIcon: Icon(Icons.work, color: AppColors.primary),
                      ),
                      cursorColor: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _numRegistroController,
                      decoration: InputDecoration(
                        labelText: 'Número de Registro',
                        labelStyle: TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryDark),
                        ),
                        prefixIcon: Icon(Icons.badge, color: AppColors.primary),
                      ),
                      cursorColor: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Campo de Senha
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primaryDark),
                      ),
                      prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                    ),
                    cursorColor: AppColors.primaryDark,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // Botão de Cadastro ou Indicador de Carregamento
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
                          if (_isProfissional) {
                            await context
                                .read<AuthProvider>()
                                .registerProfissional(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _nameController.text.trim(),
                                  _especialidadeController.text.trim(),
                                );
                          } else {
                            await context.read<AuthProvider>().registerPaciente(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _nameController.text.trim(),
                            );
                          }

                          if (context.mounted &&
                              context.read<AuthProvider>().isAuthenticated) {
                            if (_isProfissional) {
                              context.go('/homeProfissional');
                            } else {
                              context.go('/homePaciente');
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cadastro falhou'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao cadastrar'),
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
                        'Cadastrar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Botão para Voltar ao Login
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Já tem uma conta? Faça login',
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

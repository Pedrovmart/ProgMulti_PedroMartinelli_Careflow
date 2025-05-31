import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/auth/signup/signup_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const String route = '/signup';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupController(context.read<AuthProvider>()),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  // Helper para criar os TextFields padronizados
  Widget _buildAuthTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryDark),
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: AppColors.primaryDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SignupController>();

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
                  Text(
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineLarge.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ToggleButtons(
                      isSelected: [!controller.isProfissional, controller.isProfissional],
                      onPressed: (index) {
                        controller.setIsProfissional(index == 1);
                      },
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      fillColor: AppColors.primaryDark,
                      color: AppColors.primary,
                      constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
                      children: const [Text('Paciente'), Text('Profissional')],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAuthTextField(
                    controller: controller.nameController,
                    labelText: 'Nome Completo',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildAuthTextField(
                    controller: controller.emailController,
                    labelText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  if (controller.isProfissional) ...[
                    _buildAuthTextField(
                      controller: controller.especialidadeController,
                      labelText: 'Especialidade',
                      icon: Icons.medical_services_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildAuthTextField(
                      controller: controller.numRegistroController,
                      labelText: 'Número de Registro (Ex: CRM/12345)',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildAuthTextField(
                    controller: controller.passwordController,
                    labelText: 'Senha',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (controller.isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.primaryDark))
                  else
                    ElevatedButton(
                      onPressed: () async {
                        final navRoute = await controller.registerUser(context);
                        if (context.mounted) {
                          if (navRoute != null) {
                            // Navega para a rota retornada em caso de sucesso
                            context.go(navRoute);
                          } else if (controller.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(controller.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Cadastrar', style: AppTextStyles.labelLarge.copyWith(fontSize: 16)),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => controller.goToLoginPage(context),
                    child: Text(
                      'Já tem uma conta? Faça login',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark),
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

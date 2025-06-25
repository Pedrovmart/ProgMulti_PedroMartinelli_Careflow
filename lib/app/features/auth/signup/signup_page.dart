import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/auth/signup/signup_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const String route = '/signup';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupController(
        context.read<AuthProvider>(),
        context.read<ProfissionalProvider>(),
      )..init(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();
  
  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  bool _isLoadingEspecialidades = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarEspecialidades();
    });
  }
  
 
  Future<void> _carregarEspecialidades() async {
    setState(() {
      _isLoadingEspecialidades = true;
    });
    
    try {
      final controller = context.read<SignupController>();
      await controller.fetchEspecialidades();
    } catch (e) {
      debugPrint('Erro ao carregar especialidades: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar especialidades'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingEspecialidades = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }

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
                  Image.asset(
                    'assets/Logos/duas_cores_e_titulosf.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(Icons.medical_services_outlined, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Consumer<SignupController>(
                              builder: (context, controller, _) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: const Text('Selecione a especialidade'),
                                    value: controller.selectedEspecialidade,
                                    icon: _isLoadingEspecialidades
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: Center(
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          )
                                        : controller.especialidades.isEmpty
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  color: AppColors.primary,
                                                ),
                                                onPressed: _carregarEspecialidades,
                                                tooltip: 'Carregar especialidades',
                                              )
                                            : null,
                                    items: controller.especialidades.isEmpty
                                        ? [
                                            DropdownMenuItem<String>(
                                              value: '',
                                              enabled: false,
                                              child: Text(
                                                'Nenhuma especialidade encontrada',
                                                style: TextStyle(
                                                  color: AppColors.primary.withValues(alpha: 0.7),
                                                ),
                                              ),
                                            ),
                                          ]
                                        : controller.especialidades.map((esp) {
                                            return DropdownMenuItem<String>(
                                              value: esp,
                                              child: Text(esp),
                                            );
                                          }).toList(),
                                    onChanged: controller.setSelectedEspecialidade,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

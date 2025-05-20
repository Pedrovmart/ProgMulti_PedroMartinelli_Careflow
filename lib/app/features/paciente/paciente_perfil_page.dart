import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/features/paciente/paciente_perfil_controller.dart';
import 'package:careflow_app/app/widgets/profile/edit_profile_modal.dart';
import 'package:careflow_app/app/widgets/profile/profile_header_widget.dart';
import 'package:careflow_app/app/widgets/profile/profile_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PacientePerfilPage extends StatefulWidget {
  const PacientePerfilPage({super.key});

  @override
  State<PacientePerfilPage> createState() => _PacientePerfilPageState();
}

class _PacientePerfilPageState extends State<PacientePerfilPage> {
  late PacientePerfilController _controller;
  
  @override
  void initState() {
    super.initState();
    _initController();
  }
  
  void _initController() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
    
    _controller = PacientePerfilController(
      authProvider,
      pacienteProvider,
    );
    
    _controller.init();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _showEditProfileModal() {
    if (_controller.paciente == null) return;
    
    showDialog(
      context: context,
      builder: (context) => EditProfileModal(
        initialData: {
          'nome': _controller.paciente!.nome,
          'email': _controller.paciente!.email,
          'telefone': _controller.paciente!.telefone,
          'endereco': _controller.paciente!.endereco,
          'cpf': _controller.paciente!.cpf,
          'dataNascimento': '${_controller.paciente!.dataNascimento.day}/${_controller.paciente!.dataNascimento.month}/${_controller.paciente!.dataNascimento.year}',
        },
        editableFields: ['nome', 'telefone', 'endereco'],
        readOnlyFields: ['email', 'cpf', 'dataNascimento'],
        onSave: (data) async {
          try {
            await _controller.saveProfileData(data);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil atualizado com sucesso!')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro ao salvar perfil')),
              );
            }
          }
        },
      ),
    );
  }
  
  Future<void> _logout() async {
    try {
      await _controller.logout();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer logout')),
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Cabeçalho com foto de perfil
                      ProfileHeaderWidget(
                        profileImageUrl: _controller.profileImageUrl,
                        imageFile: _controller.imageFile,
                        userName: _controller.paciente?.nome ?? '',
                        userEmail: _controller.paciente?.email ?? '',
                        onImageTap: () => _controller.pickImage(),
                        onLogoutTap: _logout,
                      ),
                      
                      // Informações do usuário
                      if (_controller.paciente != null) 
                        ProfileInfoWidget(
                          userInfo: {
                            'Nome': _controller.paciente!.nome,
                            'Email': _controller.paciente!.email,
                            'Telefone': _controller.paciente!.telefone,
                            'Endereço': _controller.paciente!.endereco,
                            'CPF': _controller.paciente!.cpf,
                            'Data de Nascimento': '${_controller.paciente!.dataNascimento.day}/${_controller.paciente!.dataNascimento.month}/${_controller.paciente!.dataNascimento.year}',
                          },
                          onEditTap: _showEditProfileModal,
                        ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

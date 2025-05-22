import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/features/perfil/perfil_controller.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/widgets/profile/edit_profile_modal.dart';
import 'package:careflow_app/app/widgets/profile/profile_header_widget.dart';
import 'package:careflow_app/app/widgets/profile/profile_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late PerfilController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
    final profissionalProvider = Provider.of<ProfissionalProvider>(context, listen: false);

    _controller = PerfilController(
      authProvider,
      pacienteProvider,
      profissionalProvider,
    );

    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditProfileModal() {
    if (_controller.user == null) return;

    Map<String, String> initialData = {};
    List<String> editableFields = [];
    List<String> readOnlyFields = [];

    if (_controller.userType == 'paciente' && _controller.user is Paciente) {
      final paciente = _controller.user as Paciente;
      initialData = {
        'nome': paciente.nome,
        'email': paciente.email,
        'telefone': paciente.telefone,
        'endereco': paciente.endereco,
        'cpf': paciente.cpf,
        'dataNascimento': '${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}',
      };
      editableFields = ['nome', 'telefone', 'endereco'];
      readOnlyFields = ['email', 'cpf', 'dataNascimento'];
    } else if (_controller.userType == 'profissional' && _controller.user is Profissional) {
      final profissional = _controller.user as Profissional;
      initialData = {
        'nome': profissional.nome,
        'email': profissional.email,
        'telefone': profissional.telefone ?? '',
        'especialidade': profissional.especialidade,
        'numeroRegistro': profissional.numeroRegistro,
        // Adicionar mais campos conforme necessário para profissional
      };
      editableFields = ['nome', 'telefone', 'especialidade']; // Exemplo
      readOnlyFields = ['email', 'numeroRegistro']; // Exemplo
    }

    showDialog(
      context: context,
      builder: (context) => EditProfileModal(
        initialData: initialData,
        editableFields: editableFields,
        readOnlyFields: readOnlyFields,
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
                SnackBar(content: Text('Erro ao salvar perfil: $e')),
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

  Map<String, String> _getUserInfoMap() {
    if (_controller.user == null) return {};

    if (_controller.userType == 'paciente' && _controller.user is Paciente) {
      final paciente = _controller.user as Paciente;
      return {
        'Nome': paciente.nome,
        'Email': paciente.email,
        'Telefone': paciente.telefone,
        'Endereço': paciente.endereco,
        'CPF': paciente.cpf,
        'Data de Nascimento': '${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}',
      };
    } else if (_controller.userType == 'profissional' && _controller.user is Profissional) {
      final profissional = _controller.user as Profissional;
      return {
        'Nome': profissional.nome,
        'Email': profissional.email,
        'Telefone': profissional.telefone ?? 'Não informado',
        'Especialidade': profissional.especialidade,
        'Número de Registro': profissional.numeroRegistro,
        // Adicionar mais campos conforme necessário
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _controller.user == null 
                ? Center(child: Text('Nenhum usuário encontrado ou erro ao carregar.'))
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeaderWidget(
                        profileImageUrl: _controller.profileImageUrl,
                        imageFile: _controller.imageFile,
                        userName: _controller.user?.nome ?? '',
                        userEmail: _controller.user?.email ?? '',
                        onImageTap: _controller.canEditProfileImage ? _controller.pickImage : () {},
                        onLogoutTap: _logout,
                      ),
                      if (_controller.user != null)
                        ProfileInfoWidget(
                          userInfo: _getUserInfoMap(),
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

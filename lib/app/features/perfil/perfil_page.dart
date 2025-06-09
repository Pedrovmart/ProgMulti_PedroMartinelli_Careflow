import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/features/perfil/perfil_controller.dart';
import 'package:careflow_app/app/widgets/profile/edit_profile_modal.dart';
import 'package:careflow_app/app/widgets/profile/profile_header_widget.dart';
import 'package:careflow_app/app/widgets/profile/profile_info_widget.dart';
import 'package:flutter/material.dart';
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
    final pacienteProvider = Provider.of<PacienteProvider>(
      context,
      listen: false,
    );
    final profissionalProvider = Provider.of<ProfissionalProvider>(
      context,
      listen: false,
    );

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

    final modalData = _controller.getEditModalData();
    if (modalData.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (context) => EditProfileModal(
            initialData: Map<String, String>.from(
              modalData['initialData'] as Map,
            ),
            editableFields: List<String>.from(
              modalData['editableFields'] as List,
            ),
            readOnlyFields: List<String>.from(
              modalData['readOnlyFields'] as List,
            ),
            onSave: (data) async {
              try {
                await _controller.saveProfileData(data);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil atualizado com sucesso!'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar perfil: $e')),
                  );
                }
              }
            },
          ),
    );
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
                  ? Center(
                      child: Text(
                        'Nenhum usuário encontrado ou erro ao carregar.',
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileHeaderWidget(
                            profileImageUrl: _controller.profileImageUrl,
                            imageFile: _controller.imageFile,
                            userName: _controller.user?.nome ?? '',
                            userEmail: _controller.user?.email ?? '',
                            onImageTap: _controller.canEditProfileImage
                                ? _controller.pickImage
                                : () {},
                          ),
                          if (_controller.user != null)
                            ProfileInfoWidget(
                              userInfo: _controller.getUserInfoMap(),
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

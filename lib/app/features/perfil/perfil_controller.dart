import 'dart:developer';
import 'dart:io';

import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/models/user_model.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilController extends ChangeNotifier {
  final AuthProvider _authProvider;
  final PacienteProvider _pacienteProvider;
  final ProfissionalProvider _profissionalProvider;

  UserModel? _user;
  bool _isLoading = true;
  String? _profileImageUrl;
  File? _imageFile;
  String _userType = '';

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get profileImageUrl => _profileImageUrl;
  File? get imageFile => _imageFile;
  String get userType => _userType; 
  bool get canEditProfileImage => _userType == 'paciente';

  PerfilController(
    this._authProvider,
    this._pacienteProvider,
    this._profissionalProvider,
  ) {
    _userType = _authProvider.userType;
  }

  Future<void> init() async {
    await loadUserData();
  }

  Future<void> loadUserData() async {
    _setLoading(true);
    try {
      final firebaseUser = _authProvider.currentUser;
      if (firebaseUser == null) {
        log('Nenhum usuário autenticado encontrado');
        _setLoading(false);
        return;
      }

      final userId = firebaseUser.uid;
      _userType = _authProvider.userType; 
      log('Carregando dados para o tipo de usuário: $_userType com ID: $userId');

      if (_userType == 'paciente') {
        final paciente = await _pacienteProvider.getPacienteById(userId);
        if (paciente != null) {
          _user = paciente;
          log('Dados do paciente carregados: ${paciente.nome}');
          await _loadProfileImageForPaciente(userId);
        } else {
          log('Nenhum dado de paciente encontrado para o ID: $userId');
        }
      } else if (_userType == 'profissional') {
        final profissional = await _profissionalProvider.getProfissionalById(userId);
        if (profissional != null) {
          _user = profissional;
          log('Dados do profissional carregados: ${profissional.nome}');
          _profileImageUrl = null; 
        } else {
          log('Nenhum dado de profissional encontrado para o ID: $userId');
        }
      } else {
        log('Tipo de usuário desconhecido: $_userType');
      }
    } catch (e) {
      log('Erro ao carregar dados do usuário: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadProfileImageForPaciente(String userId) async {
    if (_userType != 'paciente') return;
    try {
      final url = await _pacienteProvider.getProfileImageUrl(userId);
      if (url != null) {
        _profileImageUrl = url;
      } else {
        _profileImageUrl = null; // Ensure it's null if not found
        log('Nenhuma imagem de perfil encontrada para o paciente $userId');
      }
      notifyListeners();
    } catch (e) {
      _profileImageUrl = null;
      log('Erro ao carregar imagem de perfil do paciente: $e');
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    if (!canEditProfileImage) return;

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
      if (_authProvider.currentUser != null && _userType == 'paciente') {
        await _uploadImageForPaciente(_authProvider.currentUser!.uid);
      }
    }
  }

  Future<void> _uploadImageForPaciente(String userId) async {
    if (_imageFile == null || _userType != 'paciente') return;

    try {
      final url = await _pacienteProvider.uploadProfileImage(userId, _imageFile!); 
      if (url != null) {
        _profileImageUrl = url;
        _imageFile = null;
        notifyListeners();
      } else {
        log('Falha ao enviar imagem do paciente: URL não retornada');
      }
    } catch (e) {
      log('Erro ao enviar imagem do paciente: $e');
      rethrow;
    }
  }

  Future<void> saveProfileData(Map<String, String> updatedData) async {
    if (_user == null) return;
    _setLoading(true);

    try {
      final userId = _authProvider.currentUser?.uid;
      if (userId == null) {
        log('Usuário não autenticado para salvar perfil');
        _setLoading(false);
        return;
      }

      if (_userType == 'paciente' && _user is Paciente) {
        if (_imageFile != null && canEditProfileImage) {
          await _uploadImageForPaciente(userId);
        }
        final currentPaciente = _user as Paciente;
        final updatedPaciente = Paciente(
          id: currentPaciente.id,
          nome: updatedData['nome'] ?? currentPaciente.nome,
          email: currentPaciente.email, 
          cpf: currentPaciente.cpf, 
          dataNascimento: currentPaciente.dataNascimento, 
          telefone: updatedData['telefone'] ?? currentPaciente.telefone,
          endereco: updatedData['endereco'] ?? currentPaciente.endereco,
          createdAt: currentPaciente.createdAt, // Preserve createdAt
        );
        await _pacienteProvider.updatePaciente(updatedPaciente);
        _user = updatedPaciente;
      } else if (_userType == 'profissional' && _user is Profissional) {
        final currentProfissional = _user as Profissional;
        final updatedProfissional = Profissional(
          id: currentProfissional.id,
          nome: updatedData['nome'] ?? currentProfissional.nome,
          email: currentProfissional.email, 
          especialidade: updatedData['especialidade'] ?? currentProfissional.especialidade,
          numeroRegistro: updatedData['numeroRegistro'] ?? currentProfissional.numeroRegistro,
          idEmpresa: currentProfissional.idEmpresa, 
          dataNascimento: updatedData['dataNascimento'] ?? currentProfissional.dataNascimento,
          telefone: updatedData['telefone'] ?? currentProfissional.telefone,
        );
        await _profissionalProvider.updateProfissional(updatedProfissional);
        _user = updatedProfissional;
      }
      notifyListeners();
    } catch (e) {
      log('Erro ao salvar dados do perfil: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Retorna um mapa com as informações formatadas do usuário para exibição
  Map<String, String> getUserInfoMap() {
    if (_user == null) return {};

    if (_userType == 'paciente' && _user is Paciente) {
      final paciente = _user as Paciente;
      return {
        'Nome': paciente.nome,
        'Email': paciente.email,
        'Telefone': paciente.telefone,
        'Endereço': paciente.endereco,
        'CPF': paciente.cpf,
        'Data de Nascimento': '${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}',
      };
    } else if (_userType == 'profissional' && _user is Profissional) {
      final profissional = _user as Profissional;
      return {
        'Nome': profissional.nome,
        'Email': profissional.email,
        'Telefone': profissional.telefone ?? 'Não informado',
        'Especialidade': profissional.especialidade,
        'Número de Registro': profissional.numeroRegistro,
      };
    }
    return {};
  }


  Map<String, dynamic> getEditModalData() {
    if (_user == null) return {};

    Map<String, String> initialData = {};
    List<String> editableFields = [];
    List<String> readOnlyFields = [];

    if (_userType == 'paciente' && _user is Paciente) {
      final paciente = _user as Paciente;
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
    } else if (_userType == 'profissional' && _user is Profissional) {
      final profissional = _user as Profissional;
      initialData = {
        'nome': profissional.nome,
        'email': profissional.email,
        'telefone': profissional.telefone ?? '',
        'especialidade': profissional.especialidade,
        'numeroRegistro': profissional.numeroRegistro,
      };
      editableFields = ['nome', 'telefone', 'especialidade'];
      readOnlyFields = ['email', 'numeroRegistro'];
    }

    return {
      'initialData': initialData,
      'editableFields': editableFields,
      'readOnlyFields': readOnlyFields,
    };
  }

  Future<void> logout() async {
    await _authProvider.signOut();
    _user = null;
    _profileImageUrl = null;
    _imageFile = null;
    _userType = '';
    notifyListeners();
  }

  void _setLoading(bool loading) {
    if (_isLoading == loading) return; // Avoid unnecessary notifications
    _isLoading = loading;
    notifyListeners();
  }

}

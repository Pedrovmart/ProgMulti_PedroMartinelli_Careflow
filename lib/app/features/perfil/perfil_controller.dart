import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
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

  /// Atualiza a URL da imagem de perfil e notifica os ouvintes
  void updateProfileImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      _profileImageUrl = imageUrl;
      notifyListeners();
      log('✅ URL da imagem de perfil atualizada para: $imageUrl');
    }
  }

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

  void _setLoading(bool loading) {
    if (_isLoading == loading) return; // Evita notificações desnecessárias
    _isLoading = loading;
    notifyListeners();
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
          await _loadProfileImageForProfissional(userId);
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
    if (_userType != 'paciente') {
      log('Tipo de usuário não é paciente, ignorando carregamento de imagem');
      return;
    }
    
    log('🔄 Carregando imagem de perfil para o paciente: $userId');
    
    try {
      log('🔍 Buscando URL da imagem de perfil...');
      final url = await _pacienteProvider.getProfileImageUrl(userId);
      
      if (url != null) {
        log('✅ URL da imagem encontrada: $url');
        _profileImageUrl = url;
        
        // Verifica se a URL é acessível
        try {
          log('🔗 Verificando acessibilidade da URL...');
          final response = await Dio().head(url);
          log('✅ URL acessível - Status: ${response.statusCode}');
        } catch (e) {
          log('⚠️ Aviso: Não foi possível acessar a URL da imagem: $e');
          log('A URL pode estar correta, mas o arquivo não está acessível publicamente');
        }
        
      } else {
        _profileImageUrl = null;
        log('ℹ️ Nenhuma URL de imagem de perfil encontrada para o paciente $userId');
      }
      
      notifyListeners();
      
    } catch (e, stackTrace) {
      _profileImageUrl = null;
      log('❌ Erro ao carregar imagem de perfil do paciente: $e');
      log('Stack trace: $stackTrace');
      notifyListeners();
      
      // Tenta novamente após um curto atraso
      await Future.delayed(const Duration(seconds: 2));
      if (_userType == 'paciente' && _user?.id == userId) {
        log('🔄 Tentando carregar a imagem novamente...');
        await _loadProfileImageForPaciente(userId);
      }
    }
  }
  
  Future<void> _loadProfileImageForProfissional(String userId) async {
    if (_userType != 'profissional') {
      log('Tipo de usuário não é profissional, ignorando carregamento de imagem');
      return;
    }
    
    log('🔄 Carregando imagem de perfil para o profissional: $userId');
    
    try {
      log('🔍 Buscando URL da imagem de perfil...');
      final url = await _profissionalProvider.getProfileImageUrl(userId);
      
      if (url != null) {
        log('✅ URL da imagem encontrada: $url');
        _profileImageUrl = url;
        
        // Verifica se a URL é acessível
        try {
          log('🔗 Verificando acessibilidade da URL...');
          final response = await Dio().head(url);
          log('✅ URL acessível - Status: ${response.statusCode}');
          
          // Atualiza o usuário com a URL da imagem
          if (_user is Profissional) {
            final profissional = _user as Profissional;
            _user = Profissional(
              id: profissional.id,
              nome: profissional.nome,
              email: profissional.email,
              especialidade: profissional.especialidade,
              numeroRegistro: profissional.numeroRegistro,
              idEmpresa: profissional.idEmpresa,
              dataNascimento: profissional.dataNascimento,
              telefone: profissional.telefone,
              profileUrlImage: url,
            );
          }
        } catch (e) {
          log('⚠️ Aviso: Não foi possível acessar a URL da imagem: $e');
          log('A URL pode estar correta, mas o arquivo não está acessível publicamente');
        }
        
      } else {
        _profileImageUrl = null;
        log('ℹ️ Nenhuma URL de imagem de perfil encontrada para o profissional $userId');
      }
      
      notifyListeners();
      
    } catch (e, stackTrace) {
      _profileImageUrl = null;
      log('❌ Erro ao carregar imagem de perfil do profissional: $e');
      log('Stack trace: $stackTrace');
      notifyListeners();
      
      // Tenta novamente após um curto atraso
      await Future.delayed(const Duration(seconds: 2));
      if (_userType == 'profissional' && _user?.id == userId) {
        log('🔄 Tentando carregar a imagem novamente...');
        await _loadProfileImageForProfissional(userId);
      }
    }
  }

  Future<void> pickImage() async {
    if (_authProvider.currentUser == null) return;

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
      
      final userId = _authProvider.currentUser!.uid;
      
      if (_userType == 'paciente') {
        await _uploadImageForPaciente(userId);
      } else if (_userType == 'profissional') {
        await _uploadImageForProfissional(userId);
      }
    }
  }

  Future<void> _uploadImageForPaciente(String userId) async {
    if (_imageFile == null || _userType != 'paciente') return;

    try {
      _setLoading(true);
      final url = await _pacienteProvider.uploadProfileImage(userId, _imageFile!);
      if (url != null) {
        _profileImageUrl = url;
        _imageFile = null;
        
        // Atualiza o usuário local com a nova URL da imagem
        if (_user is Paciente) {
          final paciente = _user as Paciente;
          _user = Paciente(
            id: paciente.id,
            nome: paciente.nome,
            email: paciente.email,
            cpf: paciente.cpf,
            dataNascimento: paciente.dataNascimento,
            telefone: paciente.telefone,
            endereco: paciente.endereco,
            profileUrlImage: url,
          );
          
          // Força a atualização do paciente no provider
          await _pacienteProvider.getPacienteById(userId);
        }
        
        notifyListeners();
      } else {
        log('Falha ao enviar imagem do paciente: URL não retornada');
      }
    } catch (e) {
      log('Erro ao enviar imagem do paciente: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _uploadImageForProfissional(String userId) async {
    if (_imageFile == null || _userType != 'profissional') return;

    try {
      _setLoading(true);
      final url = await _profissionalProvider.uploadProfileImage(userId, _imageFile!);
      if (url != null) {
        _profileImageUrl = url;
        _imageFile = null;
        
        // Atualiza o usuário local com a nova URL da imagem
        if (_user is Profissional) {
          final profissional = _user as Profissional;
          _user = Profissional(
            id: profissional.id,
            nome: profissional.nome,
            email: profissional.email,
            especialidade: profissional.especialidade,
            numeroRegistro: profissional.numeroRegistro,
            idEmpresa: profissional.idEmpresa,
            dataNascimento: profissional.dataNascimento,
            telefone: profissional.telefone,
            profileUrlImage: url,
          );
          
          // Força a atualização do profissional no provider
          await _profissionalProvider.getProfissionalById(userId);
        }
        
        notifyListeners();
      } else {
        log('Falha ao enviar imagem do profissional: URL não retornada');
      }
    } catch (e) {
      log('Erro ao enviar imagem do profissional: $e');
      rethrow;
    } finally {
      _setLoading(false);
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
    _setLoading(false);
    notifyListeners();
  }

}

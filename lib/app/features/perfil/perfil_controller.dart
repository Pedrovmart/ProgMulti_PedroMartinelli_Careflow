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
  bool _isDisposed = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get profileImageUrl => _profileImageUrl;
  File? get imageFile => _imageFile;
  String get userType => _userType;
  bool get canEditProfileImage => _userType == 'paciente' || _userType == 'profissional';

  void updateProfileImage(String imageUrl) {
    if (imageUrl.isNotEmpty && !_isDisposed) {
      _profileImageUrl = imageUrl;
      notifyListeners();
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
    if (_isLoading == loading || _isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    if (_isDisposed) return;
    
    _setLoading(true);
    try {
      final firebaseUser = _authProvider.currentUser;
      if (firebaseUser == null || _isDisposed) {
        _setLoading(false);
        return;
      }

      final userId = firebaseUser.uid;
      _userType = _authProvider.userType;

      if (_userType == 'paciente') {
        final paciente = await _pacienteProvider.getPacienteById(userId);
        if (paciente != null) {
          _user = paciente;
          await _loadProfileImageForPaciente(userId);
        }
      } else if (_userType == 'profissional') {
        final profissional = await _profissionalProvider.getProfissionalById(
          userId,
        );
        if (profissional != null) {
          _user = profissional;
          await _loadProfileImageForProfissional(userId);
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
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

        try {
          final response = await Dio().head(url);
          if (response.statusCode == 200) {
            notifyListeners();
          }
        } catch (e) {
          debugPrint('Aviso: Não foi possível acessar a URL da imagem: $e');
          _profileImageUrl = null;
        }
      } else {
        _profileImageUrl = null;
        notifyListeners();
      }
    } catch (e) {
      _profileImageUrl = null;
      notifyListeners();
      debugPrint('Erro ao carregar imagem do paciente: $e');
    }
  }

  Future<void> _loadProfileImageForProfissional(String userId) async {
    if (_userType != 'profissional') return;

    try {
      final url = await _profissionalProvider.getProfileImageUrl(userId);

      if (url != null) {
        _profileImageUrl = url;

        try {
          final response = await Dio().head(url);
          if (response.statusCode == 200) {
            if (_user is Profissional) {
              final profissional = _user as Profissional;
              _user = Profissional(
                id: profissional.id,
                nome: profissional.nome,
                email: profissional.email,
                especialidade: profissional.especialidade,
                numeroRegistro: profissional.numeroRegistro,
                dataNascimento: profissional.dataNascimento,
                telefone: profissional.telefone,
                profileUrlImage: url,
                sobre: profissional.sobre,
              );
            }
            notifyListeners();
          }
        } catch (e) {
          debugPrint('Aviso: Não foi possível acessar a URL da imagem: $e');
          _profileImageUrl = null;
        }
      } else {
        _profileImageUrl = null;
        notifyListeners();
      }
    } catch (e) {
      _profileImageUrl = null;
      notifyListeners();
      debugPrint('Erro ao carregar imagem do profissional: $e');
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

      try {
        String? imageUrl;
        if (_userType == 'paciente') {
          imageUrl = await _pacienteProvider.uploadProfileImage(
            userId,
            _imageFile!,
          );
        } else if (_userType == 'profissional') {
          imageUrl = await _profissionalProvider.uploadProfileImage(
            userId,
            _imageFile!,
          );
        }

        if (imageUrl != null) {
          _profileImageUrl = imageUrl;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Erro ao fazer upload da imagem: $e');
      }
    }
  }

  Future<void> _uploadImageForPaciente(String userId) async {
    if (_imageFile == null || _userType != 'paciente') return;

    try {
      _setLoading(true);
      final url = await _pacienteProvider.uploadProfileImage(
        userId,
        _imageFile!,
      );
      if (url != null) {
        _profileImageUrl = url;
        _imageFile = null;

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
      final url = await _profissionalProvider.uploadProfileImage(
        userId,
        _imageFile!,
      );
      if (url != null) {
        _profileImageUrl = url;
        _imageFile = null;

        if (_user is Profissional) {
          final profissional = _user as Profissional;
          _user = Profissional(
            id: profissional.id,
            nome: profissional.nome,
            email: profissional.email,
            telefone: profissional.telefone,
            especialidade: profissional.especialidade,
            numeroRegistro: profissional.numeroRegistro,
            dataNascimento: profissional.dataNascimento,
            profileUrlImage: url,
          );

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
      if (userId == null) throw Exception('Usuário não autenticado');

      if (_imageFile != null) {
        if (_userType == 'paciente') {
          await _uploadImageForPaciente(userId);
        } else if (_userType == 'profissional') {
          await _uploadImageForProfissional(userId);
        }
      }

      if (_userType == 'paciente' && _user is Paciente) {
        final paciente = _user as Paciente;

        DateTime? newDate;
        if (updatedData['dataNascimento'] != null) {
          final dateParts = updatedData['dataNascimento']!.split('/');
          if (dateParts.length == 3) {
            try {
              newDate = DateTime(
                int.parse(dateParts[2]), 
                int.parse(dateParts[1]), 
                int.parse(dateParts[0]), 
              );
            } catch (e) {
              log('Erro ao converter data: $e');
            }
          }
        }
        final updatedPaciente = Paciente(
          id: paciente.id,
          nome: updatedData['nome'] ?? paciente.nome,
          email: paciente.email,
          telefone: updatedData['telefone'] ?? paciente.telefone,
          endereco: updatedData['endereco'] ?? paciente.endereco,
          cpf: updatedData['cpf'] ?? paciente.cpf,
          dataNascimento: newDate ?? paciente.dataNascimento,
          profileUrlImage: paciente.profileUrlImage,
        );

        await _pacienteProvider.update(userId, updatedPaciente);
      } else if (_userType == 'profissional' && _user is Profissional) {
        final profissional = _user as Profissional;
        final updatedProfissional = Profissional(
          id: profissional.id,
          nome: updatedData['nome'] ?? profissional.nome,
          email: profissional.email,
          telefone: updatedData['telefone'] ?? profissional.telefone,
          especialidade:
              updatedData['especialidade'] ?? profissional.especialidade,
          numeroRegistro: profissional.numeroRegistro,
          profileUrlImage: profissional.profileUrlImage,
          sobre: updatedData['sobre'] ?? profissional.sobre,
        );

        await _profissionalProvider.update(userId, updatedProfissional);
      }

      await loadUserData();
      if (!_isDisposed) {
        notifyListeners();
      }
    } catch (e) {
      log('Erro ao salvar dados do perfil: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

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
        'Data de Nascimento':
            '${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}',
      };
    } else if (_userType == 'profissional' && _user is Profissional) {
      final profissional = _user as Profissional;
      return {
        'Nome': profissional.nome,
        'Email': profissional.email,
        'Telefone': profissional.telefone ?? 'Não informado',
        'Especialidade': profissional.especialidade,
        'Número de Registro': profissional.numeroRegistro,
        'Sobre': profissional.sobre ?? 'Não informado',
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
        'dataNascimento':
            '${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}',
      };
      editableFields = [
        'nome',
        'telefone',
        'endereco',
        'cpf',
        'dataNascimento',
      ];
      readOnlyFields = ['email'];
    } else if (_userType == 'profissional' && _user is Profissional) {
      final profissional = _user as Profissional;
      initialData = {
        'nome': profissional.nome,
        'email': profissional.email,
        'telefone': profissional.telefone ?? '',
        'especialidade': profissional.especialidade,
        'numeroRegistro': profissional.numeroRegistro,
        'sobre': profissional.sobre ?? '',
      };
      editableFields = ['nome', 'telefone', 'especialidade', 'sobre'];
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
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/paciente_provider.dart';
import 'package:careflow_app/app/models/paciente_model.dart';
import 'package:image_picker/image_picker.dart';

class PacientePerfilController extends ChangeNotifier {
  final AuthProvider _authProvider;
  final PacienteProvider _pacienteProvider;
  
  Paciente? _paciente;
  bool _isLoading = true;
  String? _profileImageUrl;
  File? _imageFile;
  
  // Getters
  Paciente? get paciente => _paciente;
  bool get isLoading => _isLoading;
  String? get profileImageUrl => _profileImageUrl;
  File? get imageFile => _imageFile;
  
  // Construtor
  PacientePerfilController(
    this._authProvider,
    this._pacienteProvider,
  );
  
  // Inicializar dados
  Future<void> init() async {
    await loadPacienteData();
  }
  
  // Carregar dados do paciente
  Future<void> loadPacienteData() async {
    _setLoading(true);
    
    try {
      // Verificar se há um usuário autenticado
      if (_authProvider.currentUser == null) {
        log('Nenhum usuário autenticado encontrado');
        return;
      }
      
      // Obter ID do usuário atual
      final userId = _authProvider.currentUser!.uid;
      log('Carregando dados do paciente com ID: $userId');
      
      // Buscar dados do paciente
      final paciente = await _pacienteProvider.getPacienteById(userId);
      
      if (paciente != null) {
        log('Dados do paciente carregados com sucesso: ${paciente.nome}');
        _paciente = paciente;
        notifyListeners();
        
        // Carregar imagem de perfil se existir
        await loadProfileImage(userId);
      } else {
        log('Nenhum dado de paciente encontrado para o ID: $userId');
      }
    } catch (e) {
      log('Erro ao carregar dados do paciente: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Carregar imagem de perfil
  Future<void> loadProfileImage(String userId) async {
    try {
      log('Carregando imagem de perfil para o usuário: $userId');
      
      final url = await _pacienteProvider.getProfileImageUrl(userId);
      if (url != null) {
        log('Imagem de perfil carregada com sucesso: $url');
        _profileImageUrl = url;
        notifyListeners();
      } else {
        log('Nenhuma imagem de perfil encontrada para o usuário');
      }
    } catch (e) {
      // Imagem não existe ainda, não é um erro
      log('Erro ao carregar imagem de perfil: $e');
    }
  }
  
  // Selecionar imagem da galeria
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Reduzir qualidade para otimizar armazenamento
      maxWidth: 800,
    );
    
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
      
      // Upload automático da imagem quando selecionada
      if (_authProvider.currentUser != null) {
        await uploadImage(_authProvider.currentUser!.uid);
      }
    }
  }
  
  // Upload da imagem
  Future<void> uploadImage(String userId) async {
    if (_imageFile == null) {
      log('Nenhuma imagem selecionada para upload');
      return;
    }
    
    try {
      log('Iniciando upload da imagem para o usuário: $userId');
      
      final url = await _pacienteProvider.uploadProfileImage(userId, _imageFile!);
      
      if (url != null) {
        log('Upload da imagem concluído com sucesso: $url');
        _profileImageUrl = url;
        _imageFile = null;
        notifyListeners();
      } else {
        log('Falha no upload da imagem: URL não retornada');
      }
    } catch (e) {
      log('Erro ao fazer upload da imagem: $e');
      rethrow;
    }
  }
  
  // Atualizar dados do perfil
  Future<void> saveProfileData(Map<String, String> updatedData) async {
    if (_paciente == null) return;
    
    _setLoading(true);
    
    try {
      final userId = _authProvider.currentUser?.uid;
      if (userId == null) {
        log('Usuário não autenticado');
        return;
      }
      
      // Upload da imagem se houver uma nova
      if (_imageFile != null) {
        await uploadImage(userId);
      }
      
      // Atualizar dados do paciente
      final updatedPaciente = Paciente(
        id: _paciente!.id,
        nome: updatedData['nome'] ?? _paciente!.nome,
        email: _paciente!.email,
        cpf: _paciente!.cpf,
        dataNascimento: _paciente!.dataNascimento,
        telefone: updatedData['telefone'] ?? _paciente!.telefone,
        endereco: updatedData['endereco'] ?? _paciente!.endereco,
      );
      
      await _pacienteProvider.updatePaciente(updatedPaciente);
      
      // Atualizar dados locais
      _paciente = updatedPaciente;
      notifyListeners();
      
    } catch (e) {
      log('Erro ao salvar perfil: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  // Fazer logout
  Future<void> logout() async {
    await _authProvider.signOut();
  }
  
  // Método auxiliar para atualizar estado de carregamento
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}

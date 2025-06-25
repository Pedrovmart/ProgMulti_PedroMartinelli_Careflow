import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class ProfissionalRoadmapController extends ChangeNotifier {
  final ConsultasProvider _consultasProvider;
  final AuthProvider _authProvider;
  
  List<ConsultaModel> _consultasDoDia = [];
  List<ConsultaModel> get consultasDoDia => _consultasDoDia;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfissionalRoadmapController({
    required ConsultasProvider consultasProvider,
    required AuthProvider authProvider,
  }) : _consultasProvider = consultasProvider,
       _authProvider = authProvider {
    carregarConsultasDoDia();
  }

  Future<void> carregarConsultasDoDia() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final profissionalId = _authProvider.currentUser?.uid;
      
      if (profissionalId == null) {
        throw Exception("Usuário não está autenticado");
      }
      
      await _consultasProvider.fetchConsultasPorProfissional(profissionalId);
      final consultas = _consultasProvider.consultas;
      
      _processarConsultasDoDia(consultas);
    } catch (e) {
      _errorMessage = "Erro ao buscar consultas: ${e.toString()}";
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void _processarConsultasDoDia(List<ConsultaModel> consultas) {
    final hoje = DateTime.now();
    
    _consultasDoDia = consultas.where((consulta) {
      final dataConsulta = _parseData(consulta.data);
      if (dataConsulta == null) return false;
      
      return dataConsulta.year == hoje.year && 
             dataConsulta.month == hoje.month && 
             dataConsulta.day == hoje.day;
    }).toList();
    

    _consultasDoDia.sort((a, b) {
      final horaA = _parseHora(a.hora);
      final horaB = _parseHora(b.hora);
      
      if (horaA == null || horaB == null) return 0;
      
      return horaA.hour * 60 + horaA.minute - (horaB.hour * 60 + horaB.minute);
    });
  }
  
  DateTime? _parseData(String data) {
    try {
      final partes = data.split('/');
      if (partes.length != 3) return null;
      
      final dia = int.tryParse(partes[0]);
      final mes = int.tryParse(partes[1]);
      final ano = int.tryParse(partes[2]);
      
      if (dia == null || mes == null || ano == null) return null;
      
      return DateTime(ano, mes, dia);
    } catch (e) {
      return null;
    }
  }
  
  TimeOfDay? _parseHora(String hora) {
    try {
      final partes = hora.split(':');
      if (partes.length < 2) return null;
      
      final horaInt = int.tryParse(partes[0]);
      final minutoInt = int.tryParse(partes[1]);
      
      if (horaInt == null || minutoInt == null) return null;
      
      return TimeOfDay(hour: horaInt, minute: minutoInt);
    } catch (e) {
      return null;
    }
  }

  void refreshConsultas() {
    carregarConsultasDoDia();
  }
}
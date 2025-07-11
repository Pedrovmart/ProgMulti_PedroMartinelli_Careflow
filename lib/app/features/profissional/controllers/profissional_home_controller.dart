import 'package:flutter/material.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/consultas_provider.dart';
import '../../../models/consulta_model.dart';
import '../../../core/repositories/n8n_paciente_repository.dart';

class ProfissionalHomeController extends ChangeNotifier {
  final ConsultasProvider _consultasProvider;
  final AuthProvider _authProvider;
  final N8nPacienteRepository _n8nPacienteRepository;
  
  String _pacientesHoje = '0';
  String _consultasTotal = '0';
  List<Map<String, dynamic>> _proximosCompromissos = [];
  bool _isLoading = false;
  bool _mostrarTodasConsultas = false;
  final List<Map<String, dynamic>> _todasAsConsultasFuturas = [];
  String? _errorMessage;
  
  // Getters
  String get pacientesHoje => _pacientesHoje;
  String get consultasTotal => _consultasTotal;
  List<Map<String, dynamic>> get proximosCompromissos => _proximosCompromissos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get mostrarTodasConsultas => _mostrarTodasConsultas;
  bool get temMaisDeTresConsultas => _todasAsConsultasFuturas.length > 3;
  
  ProfissionalHomeController({
    required ConsultasProvider consultasProvider,
    required AuthProvider authProvider,
    required N8nPacienteRepository n8nPacienteRepository,
  }) : _consultasProvider = consultasProvider,
       _authProvider = authProvider,
       _n8nPacienteRepository = n8nPacienteRepository;
  
  Future<void> carregarDados() async {
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
      
      await _processarDados(consultas);
    } catch (e) {
      _errorMessage = "Erro ao buscar dados: ${e.toString()}";
      debugPrint(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  

  void alternarExibicaoConsultas() {
    _mostrarTodasConsultas = !_mostrarTodasConsultas;
    

    _proximosCompromissos = _mostrarTodasConsultas 
        ? List.from(_todasAsConsultasFuturas)
        : _todasAsConsultasFuturas.take(3).toList();
        
    notifyListeners();
  }
  
  Future<void> _processarDados(List<ConsultaModel> consultas) async {
    _proximosCompromissos.clear();
    _todasAsConsultasFuturas.clear();
    
    final consultasValidas = consultas.where((c) => 
      c.idPaciente.isNotEmpty && 
      c.data.isNotEmpty && 
      c.hora.isNotEmpty
    ).toList();
    
    if (consultasValidas.isEmpty) {
      _pacientesHoje = '0';
      _consultasTotal = '0';
      _proximosCompromissos = [];
      notifyListeners();
      return;
    }
    

    final consultasOrdenadas = [...consultasValidas];
    consultasOrdenadas.sort((a, b) {
      final dataComparison = _compareDatas(a.data, b.data);
      if (dataComparison != 0) return dataComparison;
      
      return _compareHoras(a.hora, b.hora);
    });
    
    final hoje = DateTime.now();
    final hojeInicioDia = DateTime(hoje.year, hoje.month, hoje.day);
    
    final consultasFuturas = consultasOrdenadas.where((consulta) {
      final dataConsulta = _parseData(consulta.data);
      if (dataConsulta == null) return false;
      
      if (dataConsulta.year == hoje.year && 
          dataConsulta.month == hoje.month && 
          dataConsulta.day == hoje.day) {
        final horaConsulta = _parseHora(consulta.hora);
        if (horaConsulta != null) {
          final hojeComHora = DateTime(
            hoje.year, hoje.month, hoje.day,
            horaConsulta.hour, horaConsulta.minute
          );
          return hojeComHora.isAfter(hoje.subtract(const Duration(seconds: 1)));
        }
      }
      
      final isFutura = dataConsulta.isAfter(hojeInicioDia) || 
                      dataConsulta.isAtSameMomentAs(hojeInicioDia);
      return isFutura;
    }).toList();
    
    final consultasTotal = consultasFuturas.length.toString();
    
    final pacientesUnicos = <String>{};
    for (var consulta in consultasFuturas) {
      if (consulta.idPaciente.isNotEmpty) {
        pacientesUnicos.add(consulta.idPaciente);
      }
    }
    final pacientesHoje = pacientesUnicos.length.toString();
    
    final proximosCompromissos = <Map<String, dynamic>>[];
    
    for (var consulta in consultasFuturas) {
      final horaInicio = consulta.hora;
      final horaFim = _calcularHoraFim(horaInicio);
      final dataConsulta = _parseData(consulta.data);

      final horario = (dataConsulta != null && dataConsulta.year == hoje.year && 
                     dataConsulta.month == hoje.month && dataConsulta.day == hoje.day)
          ? '$horaInicio - $horaFim' 
          : '$horaInicio - $horaFim (${consulta.data})';

      String? profileUrlImage;
      if (consulta.idPaciente.isNotEmpty) {
        try {
          profileUrlImage = await _n8nPacienteRepository.getProfileImageUrl(consulta.idPaciente);
        } catch (e) {
          debugPrint('Erro ao buscar URL da imagem de perfil: $e');
        }
      }
      
      _todasAsConsultasFuturas.add({
        'nome': consulta.nome,
        'horario': horario,
        'id': consulta.id ?? 'temp-${consulta.idPaciente}-${consulta.data}-${consulta.hora}',
        'profileUrlImage': profileUrlImage,
      });
    }
    
    final consultasParaMostrar = _mostrarTodasConsultas 
        ? _todasAsConsultasFuturas 
        : _todasAsConsultasFuturas.take(3).toList();
        
    proximosCompromissos.addAll(consultasParaMostrar);
    
    _pacientesHoje = pacientesHoje;
    _consultasTotal = consultasTotal;
    _proximosCompromissos = proximosCompromissos;
    
    _pacientesHoje = pacientesHoje;
    _consultasTotal = consultasTotal;
    _proximosCompromissos = proximosCompromissos;
    
    notifyListeners();
  }
  
  int _compareDatas(String data1, String data2) {
    try {
      final partes1 = data1.split('/');
      final partes2 = data2.split('/');
      
      if (partes1.length != 3 || partes2.length != 3) {
        return 0; 
      }
      
      final d1 = DateTime(
        int.parse(partes1[2]), 
        int.parse(partes1[1]), 
        int.parse(partes1[0]), 
      );
      
      final d2 = DateTime(
        int.parse(partes2[2]), 
        int.parse(partes2[1]), 
        int.parse(partes2[0]), 
      );
      
      return d1.compareTo(d2);
    } catch (e) {
      return 0; 
    }
  }
  
  int _compareHoras(String hora1, String hora2) {
    try {
      int getHora24(String horaString) {
        bool isAM = horaString.contains('AM');
        bool isPM = horaString.contains('PM');
        
        String horaSemAMPM = horaString
            .replaceAll(' AM', '')
            .replaceAll(' PM', '');
        
        final partes = horaSemAMPM.split(':');
        if (partes.length != 2) return 0;
        
        int hora = int.parse(partes[0]);
        int minutos = int.parse(partes[1]);
        
        if (isPM && hora < 12) {
          hora += 12;
        } else if (isAM && hora == 12) {
          hora = 0;
        }
        
        return hora * 60 + minutos; 
      }
      
      final minutos1 = getHora24(hora1);
      final minutos2 = getHora24(hora2);
      
      return minutos1.compareTo(minutos2);
    } catch (e) {
      debugPrint('Erro ao comparar horas: ${e.toString()}');
      return 0; 
    }
  }
  
  DateTime? _parseData(String dataStr) {
    try {
      if (dataStr.isEmpty) return null;
      
      if (dataStr.contains('-')) {
        final date = DateTime.parse(dataStr).toLocal();
        return date;
      }
      
      final partes = dataStr.split('/');
      if (partes.length != 3) return null;
      
      final dia = int.tryParse(partes[0]);
      final mes = int.tryParse(partes[1]);
      final ano = int.tryParse(partes[2]);
      
      if (dia == null || mes == null || ano == null) return null;
      
      final anoAjustado = ano < 100 ? ano + 2000 : ano;
      
      final data = DateTime(anoAjustado, mes, dia);
      return data;
    } catch (e) {
      debugPrint('Erro ao fazer parse da data $dataStr: $e');
      return null;
    }
  }
  
  TimeOfDay? _parseHora(String horaStr) {
    try {
      if (horaStr.isEmpty) return null;
      
      if (horaStr.contains('T')) {
        final dateTime = DateTime.parse(horaStr).toLocal();
        return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      }
      
      final partes = horaStr.split(':');
      if (partes.length < 2) return null;
      
      final hora = int.tryParse(partes[0]);
      final minuto = int.tryParse(partes[1]);
      
      if (hora == null || minuto == null) return null;
      
      return TimeOfDay(hour: hora, minute: minuto);
    } catch (e) {
      debugPrint('Erro ao fazer parse da hora $horaStr: $e');
      return null;
    }
  }
  
  String _calcularHoraFim(String horaInicio) {
    try {
      bool isAM = horaInicio.contains('AM');
      bool isPM = horaInicio.contains('PM');
      
      if (!isAM && !isPM) {
        final partes = horaInicio.split(':');
        if (partes.length != 2) return horaInicio;
        
        var hora = int.parse(partes[0]);
        final minutos = partes[1];
        
        hora = (hora + 1) % 24;
        final horaFormatada = hora.toString().padLeft(2, '0');
        return '$horaFormatada:$minutos';
      }
      
      String periodo = isAM ? 'AM' : 'PM';
      String horaSemAMPM = horaInicio.replaceAll(' $periodo', '');
      
      final partes = horaSemAMPM.split(':');
      if (partes.length != 2) return horaInicio;
      
      var hora = int.parse(partes[0]);
      final minutos = partes[1];
      
      hora = hora + 1;
      
      if (hora > 12) {
        hora = hora - 12;       
        if (isAM) {
          periodo = 'PM';
        } else {
          periodo = 'AM';
        }
      }
      
      if (hora == 12) {
        if (isAM) {
          periodo = 'PM';
        } else {
          periodo = 'AM';
        }
      }
      
      return '$hora:$minutos $periodo';
    } catch (e) {
      debugPrint('Erro ao calcular hora fim: ${e.toString()}');
      return horaInicio; 
    }
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/models/profissional_model.dart';

class CalendarioController extends ChangeNotifier {
  final ConsultasProvider _consultasProvider;
  final ProfissionalProvider _profissionalProvider;
  final AuthProvider _authProvider;



  // Controllers
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController horaController = TextEditingController();

  // Estados
  String? _selectedProfissionalId;
  String? get selectedProfissionalId => _selectedProfissionalId;
  set selectedProfissionalId(String? value) {
    _selectedProfissionalId = value;
    notifyListeners();
  }
  
  late DateTime selectedDay;
  TimeOfDay? selectedTime;
  Map<String, List<ConsultaModel>> events = {};
  
  // Construtor com inicialização
  CalendarioController(this._consultasProvider, this._profissionalProvider, this._authProvider) {
    // Inicializa o dia selecionado com o dia atual
    final now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day);
    // Inicializa o profissional selecionado como nulo
    selectedProfissionalId = null;
  }

  // Getters
  List<Profissional> get profissionais {
    final profs = _profissionalProvider.profissionais;
    return profs.isEmpty ? [] : profs;
  }
  
  // Getter para o ProfissionalProvider (usado pelo ProxyProvider)
  ProfissionalProvider get profissionalProvider => _profissionalProvider;

  // Inicialização
  Future<void> init() async {
    dataController.text = DateFormat('dd/MM/yyyy').format(selectedDay);
    await fetchConsultations();
    await fetchProfissionais();
  }
  
  // Getters para as datas de início e fim do calendário
  DateTime get firstDay {
    final now = DateTime.now();
    return DateTime(now.year - 3, 1, 1);  // 3 anos no passado
  }

  DateTime get lastDay {
    final now = DateTime.now();
    return DateTime(now.year + 3, 12, 31); // 3 anos no futuro
  }

  // Validação de datas para o calendário
  DateTime getValidFocusedDay() {
    // Se a data for posterior à lastDay, retorna lastDay
    if (selectedDay.isAfter(lastDay)) {
      return lastDay;
    }
    
    // Se a data for anterior à firstDay, retorna firstDay
    if (selectedDay.isBefore(firstDay)) {
      return firstDay;
    }
    
    // Caso contrário, retorna a data original
    return selectedDay;
  }

  // Fetch de dados
  Future<void> fetchConsultations() async {
    try {
      final userId = _authProvider.currentUser?.uid;
      if (userId != null) {
        await _consultasProvider.fetchConsultasPorPaciente(userId);
        log('Consultas carregadas: ${_consultasProvider.consultas.length}');
        
        for (var consulta in _consultasProvider.consultas) {
          log('Consulta data: ${consulta.data}, hora: ${consulta.hora}, desc: ${consulta.descricao}');
        }
        
        events = _groupConsultationsByDate(_consultasProvider.consultas);
        log('Eventos agrupados: ${events.length} dias com consultas');
        events.forEach((key, value) {
          log('Data: $key, Consultas: ${value.length}');
        });
        notifyListeners();
      } else {
        log('Usuário não autenticado: userId é null');
      }
    } catch (e) {
      log('Erro ao fazer fetch das consultas: $e');
      throw Exception('Erro ao fazer fetch das consultas: $e');
    }
  }

  Future<void> fetchProfissionais() async {
    await _profissionalProvider.fetchProfissionais();
  }

  // Agrupamento de consultas
  Map<String, List<ConsultaModel>> _groupConsultationsByDate(
    List<ConsultaModel> consultations,
  ) {
    final groupedEvents = <String, List<ConsultaModel>>{};

    for (final consultation in consultations) {
      // A data já está no formato dd-MM-yyyy no modelo
      final dateStr = consultation.data;
      
      if (groupedEvents[dateStr] == null) {
        groupedEvents[dateStr] = [];
      }
      groupedEvents[dateStr]!.add(consultation);
    }

    return groupedEvents;
  }


  List<ConsultaModel> getEventsForDay(DateTime day) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(day);
    
    final matchingEvents = events.entries
        .where((entry) => entry.key == formattedDate)
        .expand((entry) => entry.value)
        .toList();

    log('Buscando eventos para o dia: $formattedDate');
    log('Eventos encontrados: ${matchingEvents.length}');
    
    if (matchingEvents.isNotEmpty) {
      for (var event in matchingEvents) {
        log('Evento: ${event.descricao}, hora: ${event.hora}');
      }
    }
    
    return matchingEvents;
  }
  
  // Método chamado quando um dia é selecionado no calendário
  void onDaySelected(DateTime day) {
    selectedDay = day;
    dataController.text = DateFormat('dd/MM/yyyy').format(day);
    log('Dia selecionado no controller: ${day.toString()}');
    notifyListeners();
  }
  
  // Atualiza uma consulta existente
  Future<void> atualizarConsulta(ConsultaModel consulta) async {
    try {
      await _consultasProvider.atualizarConsulta(consulta);
      // Recarregar consultas após a atualização
      await fetchConsultations();
      notifyListeners();
    } catch (e) {
      log('Erro ao atualizar consulta: $e');
      rethrow;
    }
  }
  
  // Cancela uma consulta existente
  Future<void> cancelarConsulta(String consultaId) async {
    try {
      await _consultasProvider.cancelarConsulta(consultaId);
      // Recarregar consultas após o cancelamento
      await fetchConsultations();
      notifyListeners();
    } catch (e) {
      log('Erro ao cancelar consulta: $e');
      rethrow;
    }
  }

  // Seleção de hora
  Future<void> selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSurface: Colors.blue[900]!,
          ),
        ),
        child: child!,
      ),
    );

    if (pickedTime != null && context.mounted) {
      selectedTime = pickedTime;
      horaController.text = selectedTime!.format(context);
      notifyListeners();
    }
  }

  /// Valida os dados do formulário de agendamento
  void _validarDadosAgendamento({
    required String? profissionalId,
    required String descricao,
    required TimeOfDay? time,
    required String? pacienteId,
  }) {
    if (time == null) {
      throw Exception('Selecione um horário para a consulta');
    }
    
    if (descricao.isEmpty) {
      throw Exception('A descrição da consulta é obrigatória');
    }
    
    if (profissionalId == null || profissionalId.isEmpty) {
      throw Exception('Selecione um profissional para a consulta');
    }
    
    if (pacienteId == null || pacienteId.isEmpty) {
      throw Exception('Usuário não autenticado');
    }
  }

  /// Limpa os campos do formulário após o agendamento
  void _limparCampos() {
    descricaoController.clear();
    horaController.clear();
    selectedTime = null;
    selectedProfissionalId = null;
  }

  /// Agenda uma nova consulta
  /// 
  /// Lança uma exceção caso ocorra algum erro durante o agendamento
  Future<void> agendarConsulta(BuildContext context) async {
    final pacienteId = _authProvider.currentUser?.uid;
    final profissionalId = selectedProfissionalId;
    final descricao = descricaoController.text.trim();
    final hora = horaController.text;

    try {
      // Valida os dados do formulário
      _validarDadosAgendamento(
        profissionalId: profissionalId,
        descricao: descricao,
        time: selectedTime,
        pacienteId: pacienteId,
      );

      // Cria o modelo da consulta diretamente
      final novaConsulta = ConsultaModel(
        data: DateFormat('dd/MM/yyyy').format(selectedDay),
        hora: hora,
        queixaPaciente: 'Queixa não especificada',
        idPaciente: pacienteId!,
        idMedico: profissionalId!,
        descricao: descricao,
        diagnostico: 'Diagnóstico pendente',
      );

      // Envia para o provider
      await _consultasProvider.agendarConsulta(novaConsulta);
      
      // Atualiza a interface
      _limparCampos();
      notifyListeners();
      
      // Recarrega as consultas
      if (pacienteId.isNotEmpty) {
        await fetchConsultations();
      }
    } catch (e) {
      log('Erro ao agendar consulta', error: e);
      rethrow;
    }
  }

  @override
  void dispose() {
    descricaoController.dispose();
    dataController.dispose();
    horaController.dispose();
    super.dispose();
  }
}

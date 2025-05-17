import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:intl/intl.dart';

class CalendarioController extends ChangeNotifier {
  final ConsultasProvider _consultasProvider;
  final ProfissionalProvider _profissionalProvider;
  final AuthProvider _authProvider;



  // Controllers
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController horaController = TextEditingController();

  // Estados
  String? selectedProfissionalId;
  late DateTime selectedDay;
  TimeOfDay? selectedTime;
  Map<DateTime, List<ConsultaModel>> events = {};
  
  // Construtor com inicialização
  CalendarioController(this._consultasProvider, this._profissionalProvider, this._authProvider) {
    // Inicializa o dia selecionado com o dia atual
    final now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day);
  }

  // Getters
  List<Profissional> get profissionais {
    final profs = _profissionalProvider.profissionais;
    return profs.isEmpty ? [] : profs;
  }

  // Inicialização
  Future<void> init() async {
    dataController.text = DateFormat('dd/MM/yyyy').format(selectedDay);
    await fetchConsultations();
    await fetchProfissionais();
  }
  
  // Validação de datas para o calendário
  DateTime getValidFocusedDay() {
    // Definir um intervalo de 3 anos antes e 3 anos depois do ano atual
    final now = DateTime.now();
    final lastDay = DateTime(now.year + 3, 12, 31); // 3 anos no futuro
    final firstDay = DateTime(now.year - 3, 1, 1);  // 3 anos no passado
    
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
          log('Data: ${key.toString()}, Consultas: ${value.length}');
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

  // Formatação de datas
  static String formatDate(dynamic date) {
    if (date is String) {
      if (date.contains('T')) {
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
      }
      return date;
    }
    if (date is DateTime) {
      return DateFormat('dd/MM/yyyy').format(date);
    }
    throw ArgumentError('Invalid date type: ${date.runtimeType}');
  }

  // Agrupamento de consultas
  Map<DateTime, List<ConsultaModel>> _groupConsultationsByDate(
    List<ConsultaModel> consultations,
  ) {
    final groupedEvents = <DateTime, List<ConsultaModel>>{};

    for (final consultation in consultations) {
      DateTime date;
      if (consultation.data.contains('T')) {
        date = DateTime.parse(consultation.data);
      } else {
        date = DateTime.parse('${consultation.data}T00:00:00');
      }

      date = DateTime(
        date.year,
        date.month,
        date.day,
      );

      if (groupedEvents[date] == null) {
        groupedEvents[date] = [];
      }
      groupedEvents[date]!.add(consultation);
    }

    return groupedEvents;
  }

  // Eventos do calendário
  List<ConsultaModel> getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    log('Buscando eventos para o dia: ${date.toString()}');
    log('Eventos encontrados: ${events[date]?.length ?? 0}');
    if (events[date] != null && events[date]!.isNotEmpty) {
      for (var event in events[date]!) {
        log('Evento: ${event.descricao}, hora: ${event.hora}');
      }
    }
    return events[date] ?? [];
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

  // Agendamento de consulta
  Future<void> agendarConsulta(BuildContext context) async {
    final pacienteId = _authProvider.currentUser?.uid;
    final profissionalId = selectedProfissionalId;
    final descricao = descricaoController.text;
    final hora = horaController.text;

    if (selectedTime == null ||
        descricao.isEmpty ||
        profissionalId == null) {
      throw Exception('Preencha todos os campos!');
    }

    if (pacienteId == null) {
      throw Exception('Erro: Usuário não autenticado!');
    }

    final novaConsulta = ConsultaModel(
      data: formatDate(selectedDay),
      hora: hora,
      queixaPaciente: 'Queixa não especificada',
      idPaciente: pacienteId,
      idMedico: profissionalId,
      descricao: descricao,
      diagnostico: 'Diagnóstico pendente',
    );

    try {
      await _consultasProvider.agendarConsulta(novaConsulta);
      notifyListeners();
    } catch (e) {
      log('Erro ao agendar consulta: $e');
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

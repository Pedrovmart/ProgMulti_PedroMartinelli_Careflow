import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/features/consultas/base_agendamentos_controller.dart';

class PacientesAgendamentosController extends BaseAgendamentosController {
  final ConsultasProvider _consultasProvider;
  final ProfissionalProvider _profissionalProvider;
  final AuthProvider _authProvider;

  @override
  final TextEditingController queixaPacienteController =
      TextEditingController();
  @override
  final TextEditingController dateController = TextEditingController();
  @override
  final TextEditingController timeController = TextEditingController();
  String? _selectedProfissionalId;
  @override
  String? get selectedProfissionalId => _selectedProfissionalId;
  @override
  set selectedProfissionalId(String? value) {
    _selectedProfissionalId = value;
    notifyListeners();
  }

  @override
  DateTime selectedDay;

  @override
  TimeOfDay? selectedTime;

  Map<String, List<ConsultaModel>> events = {};

  PacientesAgendamentosController(
    this._consultasProvider,
    this._profissionalProvider,
    this._authProvider,
    {Profissional? profissionalSelecionado}
  ) : selectedDay = DateTime.now() {
    final now = DateTime.now();
    dateController.text = DateFormat('dd/MM/yyyy').format(now);
    
    // Se um profissional foi pré-selecionado, use seu ID
    if (profissionalSelecionado != null) {
      selectedProfissionalId = profissionalSelecionado.id;
      log('Profissional pré-selecionado: ${profissionalSelecionado.nome} (ID: ${profissionalSelecionado.id})');
    } else {
      selectedProfissionalId = null;
    }
  }

  @override
  List<Profissional> get profissionais {
    final profs = _profissionalProvider.profissionais;
    return profs.isEmpty ? [] : profs;
  }

  ProfissionalProvider get profissionalProvider => _profissionalProvider;

  Future<void> init() async {
    selectedDay = DateTime.now().toLocal();
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDay);

    log('init - Data selecionada inicializada: ${selectedDay.toString()}');
    log('init - Data formatada: ${dateController.text}');

    await fetchConsultations();
    await fetchProfissionais();

    notifyListeners();
  }

  @override
  DateTime get firstDay {
    final now = DateTime.now();
    return DateTime(now.year - 3, 1, 1);
  }

  @override
  DateTime get lastDay {
    final now = DateTime.now();
    return DateTime(now.year + 3, 12, 31);
  }

  @override
  DateTime getValidFocusedDay() {
    if (selectedDay.isAfter(lastDay)) {
      return lastDay;
    }

    if (selectedDay.isBefore(firstDay)) {
      return firstDay;
    }

    return selectedDay;
  }

  @override
  Future<void> fetchConsultations() async {
    try {
      final userId = _authProvider.currentUser?.uid;
      if (userId != null) {
        await _consultasProvider.fetchConsultasPorPaciente(userId);
        log('Consultas carregadas: ${_consultasProvider.consultas.length}');

        for (var consulta in _consultasProvider.consultas) {
          log(
            'Consulta data: ${consulta.data}, hora: ${consulta.hora}, desc: ${consulta.descricao}',
          );
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

  @override
  Future<void> fetchProfissionais() async {
    await _profissionalProvider.fetchProfissionais();
  }

  Map<String, List<ConsultaModel>> _groupConsultationsByDate(
    List<ConsultaModel> consultations,
  ) {
    final groupedEvents = <String, List<ConsultaModel>>{};

    log(
      '_groupConsultationsByDate - Total de consultas: ${consultations.length}',
    );

    for (final consultation in consultations) {
      String dateStr = consultation.data.trim();

      if (dateStr.contains('/') && dateStr.split('/').length == 3) {
        log(
          '_groupConsultationsByDate - Data já está no formato correto: $dateStr',
        );
      } else {
        try {
          final DateTime dateTime = DateTime.parse(dateStr).toLocal();
          dateStr = DateFormat('dd/MM/yyyy').format(dateTime);
          log('_groupConsultationsByDate - Data convertida: $dateStr');
        } catch (e) {
          log(
            '_groupConsultationsByDate - Erro ao processar data: $dateStr - $e',
          );
        }
      }

      if (groupedEvents[dateStr] == null) {
        groupedEvents[dateStr] = [];
      }
      groupedEvents[dateStr]!.add(consultation);

      log('_groupConsultationsByDate - Consulta agrupada na data: $dateStr');
    }

    log(
      '_groupConsultationsByDate - Datas com eventos: ${groupedEvents.keys.join(', ')}',
    );
    return groupedEvents;
  }

  @override
  List<ConsultaModel> getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final formattedDate = DateFormat('dd/MM/yyyy').format(normalizedDay);

    log(
      'getEventsForDay - Data: ${normalizedDay.toString()}, formatada: $formattedDate',
    );
    log('getEventsForDay - Chaves disponíveis: ${events.keys.join(', ')}');

    final matchingEvents = events[formattedDate] ?? [];

    log(
      'getEventsForDay - Eventos encontrados para $formattedDate: ${matchingEvents.length}',
    );

    if (matchingEvents.isNotEmpty) {
      for (var event in matchingEvents) {
        log(
          'getEventsForDay - Evento: ${event.queixaPaciente}, data: ${event.data}, hora: ${event.hora}',
        );
      }
    }

    return List<ConsultaModel>.from(matchingEvents);
  }

  @override
  void onDaySelected(DateTime day) {
    selectedDay = day;
    dateController.text = DateFormat('dd/MM/yyyy').format(day);
    notifyListeners();
  }

  @override
  Future<void> updateAppointment(ConsultaModel consulta) async {
    try {
      await _consultasProvider.atualizarConsulta(consulta);
      await fetchConsultations();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao atualizar consulta: $e');
      rethrow;
    }
  }


  @override
  Future<void> cancelAppointment(String consultaId) async {
    try {
      await _consultasProvider.cancelarConsulta(consultaId);
      await fetchConsultations();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao cancelar consulta: $e');
      rethrow;
    }
  }

  @override
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime = picked;
      timeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      notifyListeners();
    }
  }

  @override
  Future<void> agendarConsulta(BuildContext context) async {
    final pacienteId = _authProvider.currentUser?.uid;
    final profissionalId = selectedProfissionalId;
    final queixaPaciente = queixaPacienteController.text.trim();
    final hora = timeController.text;

    try {
      final novaConsulta = ConsultaModel(
        data: DateFormat('dd/MM/yyyy').format(selectedDay),
        hora: hora,
        queixaPaciente: queixaPaciente,
        idPaciente: pacienteId!,
        idMedico: profissionalId!,
        descricao: 'Descrição pendente',
        diagnostico: 'Diagnóstico pendente',
      );

      final consultaId = await _consultasProvider.agendarConsulta(novaConsulta);
      if (consultaId.isNotEmpty) {
        log('Consulta criada com sucesso. ID: $consultaId');
      }

      queixaPacienteController.clear();
      timeController.clear();
      selectedTime = null;
      selectedProfissionalId = null;
      notifyListeners();

      if (pacienteId.isNotEmpty) {
        await fetchConsultations();
      }
    } catch (e) {
      log('CalendarioController - Erro ao agendar consulta', error: e);
      rethrow;
    }
  }

  @override
  void dispose() {
    queixaPacienteController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }
}

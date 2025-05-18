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

  final TextEditingController queixaPacienteController =
      TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  String? _selectedProfissionalId;
  String? get selectedProfissionalId => _selectedProfissionalId;
  set selectedProfissionalId(String? value) {
    _selectedProfissionalId = value;
    notifyListeners();
  }

  late DateTime selectedDay;
  TimeOfDay? selectedTime;
  Map<String, List<ConsultaModel>> events = {};

  CalendarioController(
    this._consultasProvider,
    this._profissionalProvider,
    this._authProvider,
  ) {
    final now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day);
    selectedProfissionalId = null;
  }

  List<Profissional> get profissionais {
    final profs = _profissionalProvider.profissionais;
    return profs.isEmpty ? [] : profs;
  }

  ProfissionalProvider get profissionalProvider => _profissionalProvider;

  Future<void> init() async {
    // Garantir que a data selecionada esteja no fuso horário local
    selectedDay = DateTime.now().toLocal();
    dataController.text = DateFormat('dd/MM/yyyy').format(selectedDay);

    log('init - Data selecionada inicializada: ${selectedDay.toString()}');
    log('init - Data formatada: ${dataController.text}');

    // Carregar consultas e profissionais
    await fetchConsultations();
    await fetchProfissionais();

    // Forçar notificação para atualizar a UI
    notifyListeners();
  }

  DateTime get firstDay {
    final now = DateTime.now();
    return DateTime(now.year - 3, 1, 1);
  }

  DateTime get lastDay {
    final now = DateTime.now();
    return DateTime(now.year + 3, 12, 31);
  }

  DateTime getValidFocusedDay() {
    if (selectedDay.isAfter(lastDay)) {
      return lastDay;
    }

    if (selectedDay.isBefore(firstDay)) {
      return firstDay;
    }

    return selectedDay;
  }

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
          // Se não conseguir converter, usa a data original
        }
      }

      // Adicionar a consulta ao grupo correspondente
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

  List<ConsultaModel> getEventsForDay(DateTime day) {
    // Garantir que estamos usando a data local
    final localDay = day.toLocal();
    final formattedDate = DateFormat('dd/MM/yyyy').format(localDay);

    log(
      'getEventsForDay - Data: ${localDay.toString()}, formatada: $formattedDate',
    );
    log('getEventsForDay - Chaves disponíveis: ${events.keys.join(', ')}');

    final matchingEvents =
        events.entries
            .where((entry) => entry.key.trim() == formattedDate.trim())
            .expand((entry) => entry.value)
            .toList();

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

    return matchingEvents;
  }

  void onDaySelected(DateTime day) {
    final localDay = day.toLocal();
    selectedDay = localDay;

    dataController.text = DateFormat('dd/MM/yyyy').format(localDay);

    log(
      'Dia selecionado: ${localDay.toString()}, formatado como: ${dataController.text}',
    );

    final eventsForDay = getEventsForDay(localDay);
    log('Número de eventos no dia selecionado: ${eventsForDay.length}');

    notifyListeners();
  }

  Future<void> atualizarConsulta(ConsultaModel consulta) async {
    try {
      await _consultasProvider.atualizarConsulta(consulta);
      await fetchConsultations();
      notifyListeners();
    } catch (e) {
      log('Erro ao atualizar consulta: $e');
      rethrow;
    }
  }

  Future<void> cancelarConsulta(String consultaId) async {
    try {
      await _consultasProvider.cancelarConsulta(consultaId);
      await fetchConsultations();
      notifyListeners();
    } catch (e) {
      log('Erro ao cancelar consulta: $e');
      rethrow;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder:
          (context, child) => Theme(
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

  Future<void> agendarConsulta(BuildContext context) async {
    final pacienteId = _authProvider.currentUser?.uid;
    final profissionalId = selectedProfissionalId;
    final queixaPaciente = queixaPacienteController.text.trim();
    final hora = horaController.text;

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
      horaController.clear();
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
    dataController.dispose();
    horaController.dispose();
    super.dispose();
  }
}

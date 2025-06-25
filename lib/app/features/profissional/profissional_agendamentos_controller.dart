import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/models/profissional_model.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/features/consultas/base_agendamentos_controller.dart';
import 'package:intl/intl.dart';

class ProfissionalAgendamentosController extends BaseAgendamentosController {
  final ConsultasProvider _consultasProvider;
  final AuthProvider _authProvider;
  final ProfissionalProvider _profissionalProvider;
  

  final TextEditingController _queixaPacienteController = TextEditingController();
  String? _selectedProfissionalId;
  final List<Profissional> _profissionais = [];
  
  @override
  DateTime selectedDay;
  @override
  TimeOfDay? selectedTime;
  
  final Map<String, List<ConsultaModel>> events = {};
  
  @override
  final TextEditingController dateController = TextEditingController();
  @override
  final TextEditingController timeController = TextEditingController();
  
  ProfissionalAgendamentosController(
    this._consultasProvider,
    this._authProvider, {
    required ProfissionalProvider profissionalProvider,
  })  : _profissionalProvider = profissionalProvider,
        selectedDay = DateTime.now().toLocal() {
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDay);
  }
  
  @override
  TextEditingController get queixaPacienteController => _queixaPacienteController;
  
  @override
  String? get selectedProfissionalId => _selectedProfissionalId;
  
  @override
  set selectedProfissionalId(String? value) {
    _selectedProfissionalId = value;
    notifyListeners();
  }
  
  @override
  List<Profissional> get profissionais => _profissionais;
  
  @override
  DateTime get firstDay => DateTime.now().subtract(const Duration(days: 365));
  
  @override
  DateTime get lastDay => DateTime.now().add(const Duration(days: 365));
  
  Future<void> init() async {
    selectedDay = DateTime.now().toLocal();
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDay);
    await Future.wait([
      fetchProfissionais(),
      fetchConsultations(),
    ]);
    notifyListeners();
  }

  @override
  Future<void> fetchConsultations() async {
    try {
      final profissionalId = _authProvider.currentUser?.uid;
      if (profissionalId != null) {
        await _consultasProvider.fetchConsultasPorProfissional(profissionalId);
        _updateEvents(_consultasProvider.consultas);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar consultas: $e');
      rethrow;
    }
  }
  
  void _updateEvents(List<ConsultaModel> consultations) {
    events.clear();
    for (final consultation in consultations) {
      String dateStr = consultation.data.trim();
      try {
        if (!dateStr.contains('/')) {
          final dateTime = DateTime.parse(dateStr).toLocal();
          dateStr = DateFormat('dd/MM/yyyy').format(dateTime);
        }
        events.putIfAbsent(dateStr, () => []).add(consultation);
      } catch (e) {
        debugPrint('Erro ao processar data: $dateStr - $e');
      }
    }
  }
  
  @override
  Future<void> fetchProfissionais() async {
    try {
      _profissionais.clear();
      await _profissionalProvider.fetchProfissionais();
      _profissionais.addAll(_profissionalProvider.profissionais);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching profissionais: $e');
      rethrow;
    }
  }
  
  @override
  DateTime getValidFocusedDay() {
    if (selectedDay.isAfter(lastDay)) return lastDay;
    if (selectedDay.isBefore(firstDay)) return firstDay;
    return selectedDay;
  }
  
  @override
  List<ConsultaModel> getEventsForDay(DateTime day) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(day);
    return events[formattedDate] ?? [];
  }
  
  @override
  void onDaySelected(DateTime day) {
    selectedDay = day;
    notifyListeners();
  }
  
  @override
  Future<void> updateAppointment(ConsultaModel consulta) async {
    try {
      await _consultasProvider.atualizarConsulta(consulta);
      await fetchConsultations();
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
    } catch (e) {
      debugPrint('Erro ao cancelar consulta: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      selectedTime = time;
      timeController.text = time.format(context);
    }
  }
  
  @override
  Future<void> agendarConsulta(BuildContext context) async {
    debugPrint('Agendando consulta...');
    // TODO: Implement actual consultation scheduling
  }
  
  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    _queixaPacienteController.dispose();
    super.dispose();
  }
}

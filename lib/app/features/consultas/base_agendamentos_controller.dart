import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/models/profissional_model.dart' show Profissional;

abstract class BaseAgendamentosController extends ChangeNotifier {

  DateTime get firstDay;

  DateTime get lastDay;

  DateTime get selectedDay;
  
  DateTime getValidFocusedDay();

  List<ConsultaModel> getEventsForDay(DateTime day);

  void onDaySelected(DateTime day);

  TextEditingController get queixaPacienteController;
  TextEditingController get dateController;
  TextEditingController get timeController;
  
  

  TimeOfDay? get selectedTime;
  

  set selectedTime(TimeOfDay? time);
  

  String? get selectedProfissionalId;
  set selectedProfissionalId(String? id);
  

  List<Profissional> get profissionais;
  
  Future<void> updateAppointment(ConsultaModel consulta);
  
  Future<void> atualizarConsulta(ConsultaModel consulta) => updateAppointment(consulta);

  Future<bool> cancelAppointment(String consultaId);
  
  Future<bool> cancelarConsulta(String consultaId) => cancelAppointment(consultaId);


  Future<void> selectTime(BuildContext context);
  
  
  Future<void> fetchProfissionais();
  
  Future<void> agendarConsulta(BuildContext context);
  
  Future<void> fetchConsultations();
  
  
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/' '${date.month.toString().padLeft(2, '0')}/' +
           '${date.year}';
  }

  bool hasEvents(DateTime day) {
    return getEventsForDay(day).isNotEmpty;
  }
}

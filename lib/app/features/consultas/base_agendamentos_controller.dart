import 'package:flutter/material.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/models/profissional_model.dart' show Profissional;

/// Base class for both patient and professional appointment controllers
abstract class BaseAgendamentosController extends ChangeNotifier {
  // Calendar properties
  
  /// Get the first day that should be shown in the calendar
  DateTime get firstDay;

  /// Get the last day that should be shown in the calendar
  DateTime get lastDay;

  /// Get the currently selected day
  DateTime get selectedDay;
  
  /// Get a valid focused day, ensuring it's within the valid range
  DateTime getValidFocusedDay();

  /// Get events for a specific day
  List<ConsultaModel> getEventsForDay(DateTime day);

  /// Handle when a day is selected in the calendar
  void onDaySelected(DateTime day);

  // Text controllers for form fields
  TextEditingController get queixaPacienteController;
  TextEditingController get dateController;
  TextEditingController get timeController;
  
  // Time and selection
  
  /// Get the currently selected time
  TimeOfDay? get selectedTime;
  
  /// Set the selected time
  set selectedTime(TimeOfDay? time);
  
  // Profissional selection
  String? get selectedProfissionalId;
  set selectedProfissionalId(String? id);
  
  // List of profissionais for selection
  List<Profissional> get profissionais;
  
  // Appointment operations
  
  /// Update an existing appointment
  Future<void> updateAppointment(ConsultaModel consulta);
  
  /// Alias for updateAppointment to maintain compatibility with existing code
  Future<void> atualizarConsulta(ConsultaModel consulta) => updateAppointment(consulta);

  /// Cancel an appointment
  Future<void> cancelAppointment(String consultaId);
  
  /// Alias for cancelAppointment to maintain compatibility with existing code
  Future<void> cancelarConsulta(String consultaId) => cancelAppointment(consultaId);

  /// Select a time using a time picker
  Future<void> selectTime(BuildContext context);
  
  // Data loading
  
  /// Load profissionais for selection
  Future<void> fetchProfissionais();
  
  /// Schedule a new consultation
  Future<void> agendarConsulta(BuildContext context);
  
  /// Load consultations
  Future<void> fetchConsultations();
  
  // Helper methods
  
  /// Format a date for display
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/' +
           '${date.month.toString().padLeft(2, '0')}/' +
           '${date.year}';
  }

  /// Check if a day has appointments
  bool hasEvents(DateTime day) {
    return getEventsForDay(day).isNotEmpty;
  }
}

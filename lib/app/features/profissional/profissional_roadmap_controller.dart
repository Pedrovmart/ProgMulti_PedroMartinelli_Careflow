import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class ProfissionalRoadmapController extends ChangeNotifier {
  ProfissionalRoadmapController() {
    _simularFetchConsultasDoDia();
  }

  List<ConsultaModel> _consultasDoDia = [];
  List<ConsultaModel> get consultasDoDia => _consultasDoDia;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _simularFetchConsultasDoDia() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    _consultasDoDia = [
      ConsultaModel(
        id: '1',
        data: dateFormat.format(now.add(const Duration(hours: 1))),
        hora: timeFormat.format(now.add(const Duration(hours: 1))),
        idPaciente: 'paciente_id_1',
        nome: 'Dr. Exemplo',
        queixaPaciente: 'Dor de cabeça persistente.',
      ),
      ConsultaModel(
        id: '2',
        data: dateFormat.format(now.add(const Duration(hours: 3))),
        hora: timeFormat.format(now.add(const Duration(hours: 3))),
        idPaciente: 'paciente_id_2',
        nome: 'Dr. Exemplo',
        queixaPaciente: 'Febre e mal-estar.',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void refreshConsultas() {
    _simularFetchConsultasDoDia();
  }
}
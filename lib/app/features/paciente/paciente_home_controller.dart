import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:careflow_app/app/routes/routes.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/consulta_model.dart';
import '../../models/profissional_model.dart';
import '../../core/providers/consultas_provider.dart';
import '../../core/repositories/n8n_profissional_repository.dart';
import '../../widgets/shared/upcoming_appointment_card.dart';

class PacienteHomeController with ChangeNotifier {
  final ConsultasProvider _consultasProvider;
  final N8nProfissionalRepository _profissionalRepository;
  final String _pacienteId;

  PacienteHomeController({
    required ConsultasProvider consultasProvider,
    required N8nProfissionalRepository profissionalRepository,
    required String pacienteId,
  })  : _consultasProvider = consultasProvider,
        _profissionalRepository = profissionalRepository,
        _pacienteId = pacienteId {
    fetchUpcomingAppointments();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AppointmentCardData> _upcomingAppointments = [];
  List<AppointmentCardData> get upcomingAppointments => _upcomingAppointments;

  bool get hasMoreUpcomingAppointments => _upcomingAppointments.length > 3;

  String? _error;
  String? get error => _error;

  Future<void> fetchUpcomingAppointments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _consultasProvider.fetchConsultasPorPaciente(_pacienteId);
      if (_consultasProvider.error != null) {
        throw Exception(_consultasProvider.error);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

      List<ConsultaModel> filteredConsultas = [];
      for (var consulta in _consultasProvider.consultas) {
        try {
          final consultaDate = dateFormat.parse(consulta.data);
          if (consultaDate.isAtSameMomentAs(today) || consultaDate.isAfter(today)) {
            filteredConsultas.add(consulta);
          }
        } catch (e) {
          log('Error parsing date for consulta ${consulta.id}: ${consulta.data} - $e');
        }
      }

      filteredConsultas.sort((a, b) {
        final dateA = dateFormat.parse(a.data);
        final dateB = dateFormat.parse(b.data);
        int dateComparison = dateA.compareTo(dateB);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return a.hora.compareTo(b.hora);
      });

      List<AppointmentCardData> appointmentsData = [];
      for (var consulta in filteredConsultas) {
        Profissional? profissional;
        try {
          profissional = await _profissionalRepository.getById(consulta.idMedico);
        } catch (e) {
          log('Error fetching professional ${consulta.idMedico} for consulta ${consulta.id}: $e');
        }

        appointmentsData.add(
          AppointmentCardData(
            imageUrl: profissional?.profileUrlImage ?? '',
            title: profissional?.nome ?? 'Profissional não encontrado',
            subtitle1: profissional?.especialidade ?? 'Especialidade não informada',
            subtitle2: '${consulta.data} às ${consulta.hora}',
            onTap: () {
              log('Tapped appointment with ${profissional?.nome} on ${consulta.data}');
            },
          ),
        );
      }
      _upcomingAppointments = appointmentsData;
    } catch (e) {
      log('Erro ao buscar compromissos: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToHistoricoMedico(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      GoRouter.of(context).goNamed(
        Routes.historicoPacienteName,
        extra: {
          'pacienteId': user.uid,
          'nomePaciente': user.displayName ?? 'Paciente',
        },
      );
    }
  }

  void navigateToPerfil(BuildContext context) {
    GoRouter.of(context).goNamed(Routes.perfilPacienteName);
  }

  void navigateToAgendarConsulta(BuildContext context) {
    GoRouter.of(context).goNamed(Routes.calendarioName);
  }

  void navigateToBuscarProfissionais(BuildContext context) {
    GoRouter.of(context).goNamed(Routes.pacienteBuscaName);
  }
}
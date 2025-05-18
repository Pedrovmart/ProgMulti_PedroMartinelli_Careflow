import 'dart:developer';

import 'package:intl/intl.dart';

class ConsultaModel {
  final String? id;
  final String data;
  final String hora;
  final String queixaPaciente;
  final String idPaciente;
  final String idMedico;
  final String nomeMedico;
  final String descricao;
  final String diagnostico;

  ConsultaModel({
    this.id,
    required this.data,
    required this.hora,
    this.queixaPaciente = '',
    this.idPaciente = '',
    this.idMedico = '',
    this.nomeMedico = '',
    this.descricao = '',
    this.diagnostico = '',
  });

  Map<String, dynamic> toMap() {
    final map = {
      'data': data,
      'hora': hora,
      'queixaPaciente': queixaPaciente,
      'idPaciente': idPaciente,
      'idMedico': idMedico,
      'nomeMedico': nomeMedico,
      'descricao': descricao,
      'diagnostico': diagnostico,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory ConsultaModel.fromMap(Map<String, dynamic> map) {
    String data = map['data'] ?? '';   
    if (data.isEmpty) {
      log('ConsultaModel.fromMap - Data vazia, usando data atual');
      data = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());
    } else {
      if (data.contains('/') && data.split('/').length == 3) {
        log('ConsultaModel.fromMap - Data já está no formato brasileiro: $data');
      } else {
        try {
          final dateTime = DateTime.parse(data).toLocal();
          data = DateFormat('dd/MM/yyyy').format(dateTime);
          log('ConsultaModel.fromMap - Data convertida para formato brasileiro: $data');
        } catch (e) {
          log('ConsultaModel.fromMap - Erro ao converter data: $e');
        }
      }
    }
    
    return ConsultaModel(
      id: map['id'],
      data: data,
      hora: map['hora'] ?? '',
      queixaPaciente: map['queixaPaciente'] ?? 'Queixa não especificada.',
      idPaciente: map['idPaciente'] ?? '',
      idMedico: map['idMedico'] ?? '',
      nomeMedico: map['nomeMedico'] ?? '',
      descricao: map['descricao'] ?? '',
      diagnostico: map['diagnostico'] ?? 'Diagnóstico pendente.',
    );
  }
}

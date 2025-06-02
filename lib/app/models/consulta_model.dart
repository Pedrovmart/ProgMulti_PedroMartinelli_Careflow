import 'dart:developer';

import 'package:intl/intl.dart';

class ConsultaModel {
  final String? id;
  final String data;
  final String hora;
  final String queixaPaciente;
  final String idPaciente;
  final String idMedico;
  final String nome;
  final String descricao;
  final String diagnostico;

  ConsultaModel({
    this.id,
    required this.data,
    required this.hora,
    this.queixaPaciente = '',
    this.idPaciente = '',
    this.idMedico = '',
    this.nome = '',
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
      'nome': nome,
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
    String hora = map['hora'] ?? '';
    
    log('ConsultaModel.fromMap - Data original: $data, Hora: $hora');
    
    // Se a data estiver vazia, usa a data atual local
    if (data.isEmpty) {
      data = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());
      log('Data vazia, usando data atual: $data');
    } 
    // Se a data estiver em formato ISO (vindo do servidor)
    else if (data.contains('-') && data.contains('T')) {
      try {
        final dateTime = DateTime.parse(data).toLocal();
        data = DateFormat('dd/MM/yyyy').format(dateTime);
        log('Data convertida para local: $data');
      } catch (e) {
        log('Erro ao converter data ISO: $e');
      }
    }
    // Se já estiver no formato dd/MM/yyyy, mantém como está
    else if (data.contains('/') && data.split('/').length == 3) {
      log('Data já está no formato brasileiro: $data');
    }
    
    // Processa a hora se existir
    if (hora.isNotEmpty) {
      try {
        // Se a hora estiver no formato ISO (com T e Z)
        if (hora.contains('T')) {
          final dateTime = DateTime.parse('${data}T$hora').toLocal();
          hora = DateFormat('HH:mm').format(dateTime);
          log('Hora convertida para local: $hora');
        }
        // Se já estiver no formato HH:mm, mantém como está
        else if (hora.contains(':')) {
          log('Hora já está no formato HH:mm: $hora');
        }
      } catch (e) {
        log('Erro ao processar hora: $e');
      }
    }
    
    return ConsultaModel(
      id: map['id'],
      data: data,
      hora: map['hora'] ?? '',
      queixaPaciente: map['queixaPaciente'] ?? 'Queixa não especificada.',
      idPaciente: map['idPaciente'] ?? '',
      idMedico: map['idMedico'] ?? '',
      nome: map['nomeMedico'] ?? map['nomePaciente'],
      descricao: map['descricao'] ?? '',
      diagnostico: map['diagnostico'] ?? 'Diagnóstico pendente.',
    );
  }
}

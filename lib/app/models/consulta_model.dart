import 'package:intl/intl.dart';

class ConsultaModel {
  final String? id;
  final String data;
  final String hora;
  final String queixaPaciente;
  final String idPaciente;
  final String idMedico;
  final String descricao;
  final String diagnostico;

  ConsultaModel({
    this.id,
    required this.data,
    required this.hora,
    this.queixaPaciente = '',
    this.idPaciente = '',
    this.idMedico = '',
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
      'descricao': descricao,
      'diagnostico': diagnostico,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory ConsultaModel.fromMap(Map<String, dynamic> map) {
    // Converte a data para DateTime e depois para string no formato correto
    String data = map['data'] ?? '';
    DateTime dateTime;
    
    // Se for formato ISO 8601
    if (data.contains('T')) {
      dateTime = DateTime.parse(data);
    } else {
      // Se já estiver no formato yyyy-MM-dd
      try {
        dateTime = DateTime.parse('$data T00:00:00');
      } catch (e) {
        // Se falhar, usa a data atual
        dateTime = DateTime.now();
      }
    }
    
    // Converte para string no formato correto
    data = DateFormat('yyyy-MM-dd').format(dateTime);
    
    return ConsultaModel(
      id: map['id'],
      data: data,
      hora: map['hora'] ?? '',
      queixaPaciente: map['queixaPaciente'] ?? '',
      idPaciente: map['idPaciente'] ?? '',
      idMedico: map['idMedico'] ?? '',
      descricao: map['descricao'] ?? '',
      diagnostico: map['diagnostico'] ?? '',
    );
  }
}

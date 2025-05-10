class ConsultaModel {
  final String id;
  final DateTime data;
  final String hora;
  final String queixaPaciente;
  final String idPaciente;
  final String idMedico;
  final String descricao;
  final String diagnostico;

  ConsultaModel({
    required this.id,
    required this.data,
    required this.hora,
    required this.queixaPaciente,
    required this.idPaciente,
    required this.idMedico,
    required this.descricao,
    required this.diagnostico,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'hora': hora,
      'queixaPaciente': queixaPaciente,
      'idPaciente': idPaciente,
      'idMedico': idMedico,
      'descricao': descricao,
      'diagnostico': diagnostico,
    };
  }

  factory ConsultaModel.fromMap(Map<String, dynamic> map) {
    return ConsultaModel(
      id: map['id'] ?? '',
      data: DateTime.parse(map['data']),
      hora: map['hora'],
      queixaPaciente: map['queixaPaciente'],
      idPaciente: map['idPaciente'],
      idMedico: map['idMedico'],
      descricao: map['descricao'],
      diagnostico: map['diagnostico'],
    );
  }
}

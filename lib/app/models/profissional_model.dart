import 'package:careflow_app/app/models/user_model.dart';

class Profissional extends UserModel {
  final String especialidade;
  final String numeroRegistro;
  final String idEmpresa;
  final String? dataNascimento;
  final String? telefone;

  Profissional({
    required super.id,
    required super.nome,
    required super.email,
    required this.especialidade,
    required this.numeroRegistro,
    required this.idEmpresa,
    this.dataNascimento,
    this.telefone,
  }) : super(userType: 'profissional');

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['_id'] ?? '',
      nome: json['nome'] ?? 'Sem Nome',
      email: json['email'] ?? 'Sem Email',
      especialidade: json['especialidade'] ?? 'Sem Especialidade',
      numeroRegistro: json['numRegistro'] ?? 'Sem Num. de Registro',
      idEmpresa: json['idEmpresa'] ?? '',
      dataNascimento: json['dataNascimento'],
      telefone: json['telefone'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'especialidade': especialidade,
      'numRegistro': numeroRegistro,
      'idEmpresa': idEmpresa,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
    });
    return json;
  }
}

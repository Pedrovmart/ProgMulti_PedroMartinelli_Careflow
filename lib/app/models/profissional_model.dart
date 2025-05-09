import 'package:careflow_app/app/models/user_model.dart';

class Profissional extends UserModel {
  final String especialidade;
  final String numeroRegistro;
  final String idEmpresa;

  Profissional({
    required super.id,
    required super.nome,
    required super.email,
    required this.especialidade,
    required this.numeroRegistro,
    required this.idEmpresa,
  }) : super(papel: 'profissional');

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      especialidade: json['especialidade'],
      numeroRegistro: json['numeroRegistro'],
      idEmpresa: json['idEmpresa'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'especialidade': especialidade,
      'numeroRegistro': numeroRegistro,
      'idEmpresa': idEmpresa,
    });
    return json;
  }
}

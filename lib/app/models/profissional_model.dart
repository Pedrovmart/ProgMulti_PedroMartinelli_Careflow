import 'package:careflow_app/app/models/user_model.dart';

class Profissional extends UserModel {
  final String especialidade;
  final String numeroRegistro;

  final String? dataNascimento;
  final String? telefone;

  Profissional({
    required super.id,
    required super.nome,
    required super.email,
    super.profileUrlImage,
    required this.especialidade,
    required this.numeroRegistro,
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
      dataNascimento: json['dataNascimento'],
      telefone: json['telefone'],
      profileUrlImage: json['profileUrlImage'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'especialidade': especialidade,
      'numRegistro': numeroRegistro,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
    });
    return json;
  }
}

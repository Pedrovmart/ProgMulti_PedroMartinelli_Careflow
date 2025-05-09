import 'user_model.dart';

class PacienteModel extends UserModel {
  final String cpf;
  final DateTime dataNascimento;
  final String telefone;
  final String endereco;

  PacienteModel({
    required super.id,
    required super.nome,
    required super.email,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.endereco,
  }) : super(papel: 'paciente');

  factory PacienteModel.fromJson(Map<String, dynamic> json) {
    return PacienteModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      dataNascimento: DateTime.parse(json['dataNascimento'] as String),
      telefone: json['telefone'] as String,
      endereco: json['endereco'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String(),
      'telefone': telefone,
      'endereco': endereco,
    });
    return json;
  }
}

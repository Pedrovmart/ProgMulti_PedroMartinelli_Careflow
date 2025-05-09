import 'user_model.dart';

class Paciente extends UserModel {
  final String cpf;
  final DateTime dataNascimento;
  final String telefone;
  final String endereco;

  Paciente({
    required super.id,
    required super.nome,
    required super.email,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.endereco,
  }) : super(papel: 'paciente');

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
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

class PacienteModel {
  final String id;
  final String nome;
  final String cpf;
  final DateTime dataNascimento;
  final String telefone;
  final String email;
  final String endereco;

  PacienteModel({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.email,
    required this.endereco,
  });

  factory PacienteModel.fromJson(Map<String, dynamic> json) {
    return PacienteModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      dataNascimento: DateTime.parse(json['dataNascimento'] as String),
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      endereco: json['endereco'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String(),
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
    };
  }
}

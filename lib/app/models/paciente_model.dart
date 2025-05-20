import 'user_model.dart';

class Paciente extends UserModel {
  final String cpf;
  final DateTime dataNascimento;
  final String telefone;
  final String endereco;
  final DateTime createdAt;

  Paciente({
    required String id,
    required String nome,
    required String email,
    String? cpf,
    DateTime? dataNascimento,
    String? telefone,
    String? endereco,
    DateTime? createdAt,
  }) : 
        cpf = cpf ?? '',
        dataNascimento = dataNascimento ?? DateTime(1900),
        telefone = telefone ?? '',
        endereco = endereco ?? '',
        createdAt = createdAt ?? DateTime.now(),
        super(
          id: id,
          nome: nome,
          email: email,
          userType: 'paciente',
        );

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cpf: json['cpf']?.toString(),
      dataNascimento: json['dataNascimento'] != null 
          ? DateTime.tryParse(json['dataNascimento'].toString()) ?? DateTime(1900)
          : DateTime(1900),
      telefone: json['telefone']?.toString(),
      endereco: json['endereco']?.toString(),
      createdAt: json['createdAt'] is DateTime 
          ? json['createdAt'] 
          : json['createdAt'] != null 
              ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    
    json['cpf'] = cpf;
    json['dataNascimento'] = dataNascimento.toIso8601String();
    json['telefone'] = telefone;
    json['endereco'] = endereco;
    json['createdAt'] = createdAt.toIso8601String();
    
    return json;
  }
}

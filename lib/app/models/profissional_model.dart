import 'package:careflow_app/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profissional extends UserModel {
  final String especialidade;
  final String numeroRegistro;
  final String idEmpresa;
  final DateTime? createdAt;
  final String? dataNascimento;
  final String? telefone;

  Profissional({
    required super.id,
    required super.nome,
    required super.email,
    required this.especialidade,
    required this.numeroRegistro,
    required this.idEmpresa,
    this.createdAt,
    this.dataNascimento,
    this.telefone,
  }) : super(userType: 'profissional');

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['id'] ?? '', // Garante que 'id' nunca será null
      nome: json['nome'] ?? 'Sem Nome', // Garante que 'nome' nunca será null
      email:
          json['email'] ?? 'Sem Email', // Garante que 'email' nunca será null
      especialidade:
          json['especialidade'] ?? 'Sem Especialidade', // Valor padrão
      numeroRegistro:
          json['numRegistro'] ??
          'Sem Num. de Registro', // Corrigido para 'numRegistro'
      idEmpresa: json['idEmpresa'] ?? '', // Valor padrão para 'idEmpresa'
      createdAt:
          json['createdAt'] != null
              ? (json['createdAt'] as Timestamp).toDate()
              : null, // Converte Timestamp para DateTime
      dataNascimento: json['dataNascimento'], // Permite null
      telefone: json['telefone'], // Permite null
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'especialidade': especialidade,
      'numRegistro': numeroRegistro, // Corrigido para 'numRegistro'
      'idEmpresa': idEmpresa,
      'createdAt': createdAt, // Adicionado
      'dataNascimento': dataNascimento, // Adicionado
      'telefone': telefone, // Adicionado
    });
    return json;
  }
}

class UserModel {
  final String id;
  final String nome;
  final String email;
  final String papel; // 'paciente' ou 'profissional'

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.papel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      papel: json['papel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'email': email, 'papel': papel};
  }
}

class UserModel {
  final String id;
  final String nome;
  final String email;
  final String userType; // 'paciente' ou 'profissional'

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'email': email, 'userType': userType};
  }
}

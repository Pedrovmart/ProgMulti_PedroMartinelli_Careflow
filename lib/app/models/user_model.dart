class UserModel {
  final String id;
  final String nome;
  final String email;
  final String userType;
  final String? profileUrlImage;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.userType,
    this.profileUrlImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      userType: json['userType'],
      profileUrlImage: json['profileUrlImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'userType': userType,
      'profileUrlImage': profileUrlImage,
    };
  }
}

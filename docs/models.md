# Modelos de Dados do CareFlow App

## Visão Geral

Os modelos de dados no CareFlow App representam as entidades principais do sistema e são responsáveis por encapsular os dados e comportamentos relacionados a essas entidades. Os modelos seguem uma estrutura hierárquica, com classes base e classes derivadas para tipos específicos de usuários.

## Hierarquia de Modelos

### UserModel

`UserModel` é a classe base para todos os tipos de usuários no sistema. Ela contém os atributos comuns a todos os usuários.

```dart
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
```

### Profissional

`Profissional` estende `UserModel` e adiciona atributos específicos para profissionais de saúde.

```dart
class Profissional extends UserModel {
  final String especialidade;
  final String numeroRegistro;
  final String? dataNascimento;
  final String? telefone;
  final String? sobre;

  Profissional({
    required super.id,
    required super.nome,
    required super.email,
    super.profileUrlImage,
    required this.especialidade,
    required this.numeroRegistro,
    this.dataNascimento,
    this.telefone,
    this.sobre,
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
      sobre: json['sobre'],
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
      'sobre': sobre,
    });
    return json;
  }
}
```

### Paciente

`Paciente` estende `UserModel` e adiciona atributos específicos para pacientes.

```dart
class Paciente extends UserModel {
  final String? dataNascimento;
  final String? telefone;
  final String? endereco;
  final List<String>? condicoesPreexistentes;

  Paciente({
    required super.id,
    required super.nome,
    required super.email,
    super.profileUrlImage,
    this.dataNascimento,
    this.telefone,
    this.endereco,
    this.condicoesPreexistentes,
  }) : super(userType: 'paciente');

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Sem Nome',
      email: json['email'] ?? 'Sem Email',
      profileUrlImage: json['profileUrlImage'],
      dataNascimento: json['dataNascimento'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      condicoesPreexistentes: json['condicoesPreexistentes'] != null
          ? List<String>.from(json['condicoesPreexistentes'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'endereco': endereco,
      'condicoesPreexistentes': condicoesPreexistentes,
    });
    return json;
  }
}
```

### Consulta

`Consulta` representa uma consulta médica entre um paciente e um profissional.

```dart
class Consulta {
  final String id;
  final String idPaciente;
  final String idProfissional;
  final String nomePaciente;
  final String nomeProfissional;
  final DateTime data;
  final String horario;
  final String status;
  final String? observacoes;

  Consulta({
    required this.id,
    required this.idPaciente,
    required this.idProfissional,
    required this.nomePaciente,
    required this.nomeProfissional,
    required this.data,
    required this.horario,
    required this.status,
    this.observacoes,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] ?? '',
      idPaciente: json['idPaciente'] ?? '',
      idProfissional: json['idProfissional'] ?? '',
      nomePaciente: json['nomePaciente'] ?? 'Paciente',
      nomeProfissional: json['nomeProfissional'] ?? 'Profissional',
      data: json['data'] != null
          ? (json['data'] is DateTime
              ? json['data']
              : DateTime.parse(json['data']))
          : DateTime.now(),
      horario: json['horario'] ?? '',
      status: json['status'] ?? 'pendente',
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPaciente': idPaciente,
      'idProfissional': idProfissional,
      'nomePaciente': nomePaciente,
      'nomeProfissional': nomeProfissional,
      'data': data.toIso8601String(),
      'horario': horario,
      'status': status,
      'observacoes': observacoes,
    };
  }
}
```

### Histórico

`Historico` representa um registro no histórico médico de um paciente.

```dart
class Historico {
  final String id;
  final String pacienteId;
  final String profissionalId;
  final DateTime data;
  final String output;
  final DateTime createdAt;

  Historico({
    required this.id,
    required this.pacienteId,
    required this.profissionalId,
    required this.data,
    required this.output,
    required this.createdAt,
  });

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
      id: json['id'] ?? '',
      pacienteId: json['pacienteId'] ?? '',
      profissionalId: json['profissionalId'] ?? '',
      data: json['data'] != null
          ? (json['data'] is DateTime
              ? json['data']
              : DateTime.parse(json['data']))
          : DateTime.now(),
      output: json['output'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pacienteId': pacienteId,
      'profissionalId': profissionalId,
      'data': data.toIso8601String(),
      'output': output,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
```

## Uso dos Modelos

### Serialização e Deserialização

Os modelos incluem métodos `fromJson` e `toJson` para facilitar a conversão entre objetos Dart e dados JSON. Isso é especialmente útil ao trabalhar com APIs e bancos de dados.

```dart
// Deserialização
final profissionalData = await FirebaseFirestore.instance
    .collection('usuarios')
    .doc('profissionais')
    .collection('profissionais')
    .doc(uid)
    .get();
    
final profissional = Profissional.fromJson(profissionalData.data()!);

// Serialização
await FirebaseFirestore.instance
    .collection('usuarios')
    .doc('profissionais')
    .collection('profissionais')
    .doc(uid)
    .set(profissional.toJson());
```

### Herança e Polimorfismo

A hierarquia de modelos permite tratar diferentes tipos de usuários de forma polimórfica quando necessário:

```dart
UserModel getUser(String userType, Map<String, dynamic> userData) {
  if (userType == 'paciente') {
    return Paciente.fromJson(userData);
  } else if (userType == 'profissional') {
    return Profissional.fromJson(userData);
  }
  return UserModel.fromJson(userData);
}
```

## Boas Práticas

1. **Imutabilidade**: Os modelos são imutáveis (todos os campos são `final`), o que ajuda a prevenir bugs relacionados a mudanças de estado inesperadas.

2. **Valores Padrão**: Os métodos `fromJson` incluem valores padrão para campos que podem estar ausentes, aumentando a robustez do código.

3. **Tipagem Forte**: Todos os campos têm tipos específicos, aproveitando o sistema de tipos do Dart para detectar erros em tempo de compilação.

4. **Encapsulamento**: Os modelos encapsulam a lógica relacionada à serialização e deserialização, mantendo essa responsabilidade em um único lugar.

5. **Extensibilidade**: A hierarquia de classes permite adicionar novos tipos de usuários ou entidades de forma organizada.

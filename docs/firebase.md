# Integração com Firebase no CareFlow App

## Visão Geral

O CareFlow App utiliza o Firebase como principal backend para autenticação de usuários e armazenamento de dados. O Firebase oferece uma solução completa para desenvolvimento de aplicativos móveis, incluindo autenticação, banco de dados em tempo real, armazenamento de arquivos e muito mais.

## Serviços Utilizados

### Firebase Authentication

O Firebase Authentication é utilizado para gerenciar a autenticação de usuários no aplicativo. O serviço permite:

- Registro de usuários com email e senha
- Login de usuários
- Gerenciamento de sessão
- Recuperação de senha

### Cloud Firestore

O Cloud Firestore é um banco de dados NoSQL baseado em documentos utilizado para armazenar dados do aplicativo. A estrutura de dados no Firestore é organizada da seguinte forma:

```
firestore/
├── usuarios/
│   ├── pacientes/
│   │   └── pacientes/
│   │       ├── [uid_paciente_1]/
│   │       │   ├── nome
│   │       │   ├── email
│   │       │   ├── userType
│   │       │   └── createdAt
│   │       └── [uid_paciente_2]/
│   │           └── ...
│   └── profissionais/
│       └── profissionais/
│           ├── [uid_profissional_1]/
│           │   ├── nome
│           │   ├── email
│           │   ├── especialidade
│           │   ├── numRegistro
│           │   ├── userType
│           │   └── createdAt
│           └── [uid_profissional_2]/
│               └── ...
└── consultas/
    ├── [id_consulta_1]/
    │   ├── idPaciente
    │   ├── idProfissional
    │   ├── data
    │   ├── horario
    │   ├── status
    │   └── observacoes
    └── [id_consulta_2]/
        └── ...
```

## Implementação

### Configuração do Firebase

A configuração do Firebase é realizada no arquivo `main.dart` antes da inicialização do aplicativo:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SupabaseService.initializeGlobally();
  runApp(const App());
}
```

### Autenticação

A autenticação é gerenciada pela classe `AuthRepository`, que encapsula as operações do Firebase Authentication:

```dart
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw Exception("Falha ao fazer login: ${e.toString()}");
    }
  }

  // Outros métodos de autenticação...
}
```

### Armazenamento de Dados

O acesso ao Firestore é gerenciado por repositórios específicos para cada entidade do aplicativo. Por exemplo, o `AuthRepository` também gerencia o armazenamento de dados de usuários:

```dart
Future<User?> registerPaciente(
  String email,
  String password,
  String name,
) async {
  try {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user?.updateDisplayName(name);
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc('pacientes')
        .collection('pacientes')
        .doc(userCredential.user!.uid)
        .set({
          'nome': name,
          'email': email,
          'userType': 'paciente',
          'createdAt': FieldValue.serverTimestamp(),
        });
    return userCredential.user;
  } catch (e) {
    throw Exception("Falha ao registrar paciente: ${e.toString()}");
  }
}
```

## Consultas ao Firestore

As consultas ao Firestore são realizadas pelos repositórios específicos de cada feature. Por exemplo, para obter o histórico de um paciente:

```dart
Future<List<dynamic>> getHistoricoPaciente({
  required String pacienteId,
}) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('historicos')
        .where('pacienteId', isEqualTo: pacienteId)
        .orderBy('createdAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    throw Exception("Erro ao obter histórico do paciente: ${e.toString()}");
  }
}
```

## Segurança

### Regras de Segurança do Firestore

As regras de segurança do Firestore controlam o acesso aos dados com base no estado de autenticação e no tipo de usuário:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Verifica se o usuário está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Verifica se o usuário é um paciente
    function isPaciente(userId) {
      return exists(/databases/$(database)/documents/usuarios/pacientes/pacientes/$(userId));
    }
    
    // Verifica se o usuário é um profissional
    function isProfissional(userId) {
      return exists(/databases/$(database)/documents/usuarios/profissionais/profissionais/$(userId));
    }
    
    // Regras para dados de pacientes
    match /usuarios/pacientes/pacientes/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && request.auth.uid == userId;
    }
    
    // Regras para dados de profissionais
    match /usuarios/profissionais/profissionais/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && request.auth.uid == userId;
    }
    
    // Regras para consultas
    match /consultas/{consultaId} {
      allow read: if isAuthenticated() && 
        (isPaciente(request.auth.uid) || isProfissional(request.auth.uid));
      allow write: if isAuthenticated() && isProfissional(request.auth.uid);
    }
  }
}
```

## Boas Práticas

1. **Tratamento de Erros**: Sempre trate erros nas operações do Firebase para fornecer feedback adequado ao usuário.
2. **Índices**: Configure índices para consultas complexas no Firestore para melhorar o desempenho.
3. **Segurança**: Implemente regras de segurança adequadas para proteger os dados.
4. **Offline**: Configure o Firestore para funcionar offline quando necessário.
5. **Paginação**: Utilize paginação para consultas que retornam muitos resultados.

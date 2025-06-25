# Autenticação no CareFlow App

## Visão Geral

O sistema de autenticação do CareFlow App é baseado no Firebase Authentication, com funcionalidades adicionais para diferenciar entre usuários pacientes e profissionais de saúde. O fluxo de autenticação inclui registro, login e gerenciamento de sessão.

## Componentes Principais

### AuthProvider

O `AuthProvider` é a classe central que gerencia o estado de autenticação do usuário. Ele é implementado como um `ChangeNotifier` para notificar os widgets quando o estado de autenticação muda.

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  firebase_auth.User? _currentUser;
  String _userType = '';
  bool _initialized = false;
  
  // Getters e métodos de autenticação
}
```

### AuthRepository

O `AuthRepository` encapsula a lógica de comunicação com o Firebase Authentication e o Firestore para operações de autenticação.

```dart
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // Métodos de autenticação
}
```

## Fluxos de Autenticação

### Registro de Paciente

1. O usuário fornece email, senha e nome
2. `AuthProvider.registerPaciente()` é chamado
3. `AuthRepository` cria uma conta no Firebase Authentication
4. Os dados do paciente são armazenados no Firestore
5. O usuário é autenticado automaticamente

```dart
Future<void> registerPaciente(
  String email,
  String password,
  String name,
) async {
  try {
    _currentUser = await _authRepository.registerPaciente(
      email,
      password,
      name,
    );
    _userType = 'paciente';
    notifyListeners();
  } catch (e) {
    throw Exception("Erro ao registrar paciente: ${e.toString()}");
  }
}
```

### Registro de Profissional

1. O usuário fornece email, senha, nome, especialidade e número de registro
2. `AuthProvider.registerProfissional()` é chamado
3. `AuthRepository` cria uma conta no Firebase Authentication
4. Os dados do profissional são armazenados no Firestore
5. Os dados do profissional também são armazenados no Supabase
6. O usuário é autenticado automaticamente

```dart
Future<void> registerProfissional(
  String email,
  String password,
  String name,
  String especialidade,
  String numRegistro,
) async {
  try {
    _currentUser = await _authRepository.registerProfissional(
      email,
      password,
      name,
      especialidade,
      numRegistro,
    );
    _userType = 'profissional';
    notifyListeners();
  } catch (e) {
    throw Exception("Erro ao registrar profissional: ${e.toString()}");
  }
}
```

### Login

1. O usuário fornece email e senha
2. `AuthProvider.login()` é chamado
3. `AuthRepository` autentica o usuário no Firebase Authentication
4. O tipo de usuário (paciente ou profissional) é determinado consultando o Firestore
5. O estado de autenticação é atualizado

```dart
Future<void> login(String email, String password) async {
  try {
    _currentUser = await _authRepository.loginWithEmailAndPassword(
      email,
      password,
    );
    
    if (_currentUser != null) {
      _userType = await _authRepository.getUserType(_currentUser!.uid);
    }
    notifyListeners();
  } catch (e) {
    throw Exception("Erro ao fazer login: ${e.toString()}");
  }
}
```

### Logout

1. O usuário solicita logout
2. `AuthProvider.signOut()` é chamado
3. `AuthRepository` encerra a sessão no Firebase Authentication
4. O estado de autenticação é atualizado

```dart
Future<void> signOut() async {
  await _authRepository.signOut();
  _currentUser = null;
  _userType = '';
  notifyListeners();
}
```

## Determinação do Tipo de Usuário

O método `getUserType` no `AuthRepository` determina se o usuário é um paciente ou um profissional consultando as coleções correspondentes no Firestore:

```dart
Future<String> getUserType(String uid) async {
  final pacienteDoc = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc('pacientes')
      .collection('pacientes')
      .doc(uid)
      .get();
      
  if (pacienteDoc.exists) {
    return 'paciente';
  }

  final profissionalDoc = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc('profissionais')
      .collection('profissionais')
      .doc(uid)
      .get();
      
  if (profissionalDoc.exists) {
    return 'profissional';
  }

  throw Exception('Usuário não encontrado.');
}
```

## Integração com Rotas

O `AuthProvider` é usado pelo sistema de rotas (`go_router`) para redirecionar o usuário com base em seu estado de autenticação:

```dart
redirect: (context, state) {
  if (!authProvider.initialized) {
    return null;
  }

  final user = authProvider.currentUser;
  final location = state.uri.toString();

  if (user == null &&
      location != LoginPage.route &&
      location != SignUpPage.route) {
    return LoginPage.route;
  }

  if (user != null &&
      (location == LoginPage.route || location == SignUpPage.route)) {
    if (authProvider.userType == 'paciente') {
      return PacienteHomePage.route;
    } else if (authProvider.userType == 'profissional') {
      return ProfissionalHomePage.route;
    }
  }

  return null;
}
```

## Boas Práticas de Segurança

1. Senhas são gerenciadas pelo Firebase Authentication e nunca armazenadas diretamente
2. Validação de dados é realizada tanto no cliente quanto no servidor
3. Regras de segurança do Firestore controlam o acesso aos dados
4. Tokens de autenticação são gerenciados automaticamente pelo Firebase SDK

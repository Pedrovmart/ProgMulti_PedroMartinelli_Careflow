# Gerenciamento de Estado com Provider no CareFlow App

## Visão Geral

O CareFlow App utiliza o padrão Provider para gerenciamento de estado. O Provider é uma solução de gerenciamento de estado recomendada pelo Flutter, que implementa o padrão InheritedWidget de forma mais simples e eficiente. Este documento descreve como o Provider é utilizado no aplicativo para gerenciar o estado global e local.

## Estrutura de Providers

### Providers Globais

Os providers globais são definidos na classe `App` e estão disponíveis para toda a aplicação:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ProfissionalProvider()),
    ChangeNotifierProvider(create: (_) => PacienteProvider()),
    ChangeNotifierProvider(create: (_) => ConsultasProvider()),
    Provider<N8nProfissionalRepository>(create: (_) => DependencyInjection.profissionalRepository),
    ChangeNotifierProxyProvider3<
      AuthProvider,
      PacienteProvider,
      ProfissionalProvider,
      PerfilController
    >(
      create: (context) => PerfilController(
        context.read<AuthProvider>(),
        context.read<PacienteProvider>(),
        context.read<ProfissionalProvider>(),
      ),
      update: (context, auth, paciente, profissional, previous) =>
          PerfilController(auth, paciente, profissional),
    ),
  ],
  child: Consumer<AuthProvider>(
    builder: (context, authProvider, _) {
      return MaterialApp.router(
        // ...
      );
    },
  ),
)
```

### Providers Locais

Os providers locais são definidos em páginas específicas e estão disponíveis apenas para a árvore de widgets abaixo delas:

```dart
ChangeNotifierProvider(
  create: (context) => HistoricoPacienteController(
    Provider.of<PacienteProvider>(context, listen: false),
  )..carregarHistoricoPaciente(
    pacienteId: pacienteId,
  ),
  child: _HistoricoPacienteView(
    pacienteId: pacienteId,
    nomePaciente: nomePaciente,
  ),
)
```

## Tipos de Providers

### ChangeNotifierProvider

Utilizado para providers que estendem `ChangeNotifier` e notificam seus ouvintes quando seu estado interno muda:

```dart
ChangeNotifierProvider(
  create: (_) => AuthProvider(),
  child: // ...
)
```

### Provider

Utilizado para valores que não mudam ou que não precisam notificar widgets sobre mudanças:

```dart
Provider<N8nProfissionalRepository>(
  create: (_) => DependencyInjection.profissionalRepository,
  child: // ...
)
```

### ChangeNotifierProxyProvider

Utilizado quando um provider depende de outros providers e precisa ser atualizado quando esses providers mudam:

```dart
ChangeNotifierProxyProvider3<
  AuthProvider,
  PacienteProvider,
  ProfissionalProvider,
  PerfilController
>(
  create: (context) => PerfilController(
    context.read<AuthProvider>(),
    context.read<PacienteProvider>(),
    context.read<ProfissionalProvider>(),
  ),
  update: (context, auth, paciente, profissional, previous) =>
      PerfilController(auth, paciente, profissional),
)
```

## Implementação de Providers

### AuthProvider

O `AuthProvider` gerencia o estado de autenticação do usuário:

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  firebase_auth.User? _currentUser;
  String _userType = '';
  bool _initialized = false;

  // Getters
  firebase_auth.User? get currentUser => _currentUser;
  String get userType => _userType;
  bool get isAuthenticated => _currentUser != null;
  bool get initialized => _initialized;

  // Métodos
  Future<void> login(String email, String password) async {
    // Implementação...
    notifyListeners();
  }

  Future<void> signOut() async {
    // Implementação...
    notifyListeners();
  }
}
```

### PacienteProvider

O `PacienteProvider` gerencia o estado relacionado aos pacientes:

```dart
class PacienteProvider extends ChangeNotifier {
  final PacienteRepository _pacienteRepository = PacienteRepository();
  
  Paciente? _currentPaciente;
  List<Historico>? _historico;
  
  // Getters
  Paciente? get currentPaciente => _currentPaciente;
  List<Historico>? get historico => _historico;
  
  // Métodos
  Future<void> loadPaciente(String uid) async {
    // Implementação...
    notifyListeners();
  }
  
  Future<List<dynamic>> getHistoricoPaciente({required String pacienteId}) async {
    // Implementação...
    notifyListeners();
    return _historico ?? [];
  }
}
```

## Acesso aos Providers

### Leitura de Valores (sem observar mudanças)

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
// ou
final authProvider = context.read<AuthProvider>();
```

### Observação de Valores (com reconstrução automática)

```dart
final authProvider = Provider.of<AuthProvider>(context);
// ou
final authProvider = context.watch<AuthProvider>();
```

### Uso do Consumer

O widget `Consumer` é utilizado para reconstruir apenas partes específicas da UI quando um provider muda:

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text('Usuário: ${authProvider.currentUser?.displayName ?? "Não autenticado"}');
  },
)
```

## Fluxo de Dados

1. **Widget** chama um método no **Provider**
2. **Provider** atualiza seu estado interno e chama `notifyListeners()`
3. Todos os widgets que observam o provider são reconstruídos

```
Widget -> Provider.method() -> Provider.notifyListeners() -> Widget rebuild
```

## Padrões de Uso

### Padrão Repository-Provider

O aplicativo utiliza o padrão Repository-Provider, onde:

1. **Repositories** encapsulam a lógica de acesso a dados
2. **Providers** utilizam repositories e expõem dados e métodos para os widgets

```
Widget -> Provider -> Repository -> External Service (Firebase, Supabase)
```

### Padrão Controller-Provider

Para funcionalidades específicas de uma página, o aplicativo utiliza o padrão Controller-Provider, onde:

1. **Controllers** estendem `ChangeNotifier` e gerenciam o estado local
2. **Providers** globais são injetados nos controllers

```
Widget -> Controller -> Global Provider -> Repository
```

## Boas Práticas

1. **Separação de Responsabilidades**: Cada provider tem uma responsabilidade bem definida
2. **Granularidade**: Divida providers grandes em providers menores e mais específicos
3. **Lazy Loading**: Os providers são inicializados apenas quando necessários
4. **Injeção de Dependências**: Use `Provider.of` ou `context.read` para injetar providers em outros providers
5. **Minimização de Reconstruções**: Use `Consumer` ou `Selector` para reconstruir apenas partes específicas da UI
6. **Tratamento de Erros**: Implemente tratamento de erros adequado em todos os providers

# Navegação no CareFlow App

## Visão Geral

O CareFlow App utiliza o pacote `go_router` para gerenciar a navegação entre telas. Esta abordagem oferece uma navegação declarativa, tipada e baseada em rotas, facilitando a organização e manutenção das rotas do aplicativo.

## Estrutura de Rotas

As rotas do aplicativo são definidas na classe `Routes` em `lib/app/routes/routes.dart`. Esta classe contém:

- Constantes para nomes de rotas
- Método para criar o roteador
- Lógica de redirecionamento baseada no estado de autenticação

```dart
sealed class Routes {
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String homePacienteName = 'homePaciente';
  // Outras constantes de nomes de rotas...

  static GoRouter createRouter({
    String? initialLocation,
    required AuthProvider authProvider,
  }) {
    // Configuração do roteador...
  }
}
```

## Tipos de Rotas

### Rotas Básicas

Rotas simples que navegam para uma única página.

```dart
GoRoute(
  path: LoginPage.route,
  name: loginName,
  builder: (context, state) => const LoginPage(),
),
```

### Rotas com Parâmetros

Rotas que aceitam parâmetros na URL ou como objetos extras.

```dart
GoRoute(
  path: '/profissional/consulta-detalhes/:idConsulta',
  name: profissionalConsultaDetalhesName,
  builder: (context, state) {
    final args = state.extra as Map<String, dynamic>? ?? {};
    return ConsultaDetalhesPage(
      idProfissional: args['idProfissional'] ?? '',
      idPaciente: args['idPaciente'] ?? '',
      nomePaciente: args['nomePaciente'] ?? 'Paciente',
    );
  },
),
```

### Rotas Aninhadas (ShellRoute)

Rotas que compartilham um layout comum, como uma barra de navegação inferior.

```dart
ShellRoute(
  builder: (context, state, child) =>
      PacienteMainPage(state: state, child: child),
  routes: [
    GoRoute(
      path: PacienteHomePage.route,
      name: homePacienteName,
      builder: (context, state) => PacienteHomePage(),
    ),
    // Outras rotas aninhadas...
  ],
),
```

## Redirecionamento Baseado em Autenticação

O sistema de rotas inclui lógica de redirecionamento que verifica o estado de autenticação do usuário e o redireciona conforme necessário:

```dart
redirect: (context, state) {
  if (!authProvider.initialized) {
    return null;
  }

  final user = authProvider.currentUser;
  final location = state.uri.toString();

  // Redireciona para login se não estiver autenticado
  if (user == null &&
      location != LoginPage.route &&
      location != SignUpPage.route) {
    return LoginPage.route;
  }

  // Redireciona para a página principal se já estiver autenticado
  if (user != null &&
      (location == LoginPage.route || location == SignUpPage.route)) {
    if (authProvider.userType == 'paciente') {
      return PacienteHomePage.route;
    } else if (authProvider.userType == 'profissional') {
      return ProfissionalHomePage.route;
    }
  }

  return null;
},
```

## Navegação por Tipo de Usuário

O aplicativo tem fluxos de navegação diferentes para pacientes e profissionais:

### Fluxo de Paciente

```
ShellRoute (PacienteMainPage)
├── PacienteHomePage
├── ProfissionalSearchPage
├── ProfissionalPerfilPublicoPage
├── PacientesAgendamentosPage
├── PerfilPage
└── HistoricoPacientePage
```

### Fluxo de Profissional

```
ShellRoute (ProfissionalMainPage)
├── ProfissionalHomePage
├── ProfissionalAgendamentosPage
├── ProfissionalRoadmapPage
├── PerfilPage
└── ConsultaDetalhesPage
```

## Uso da Navegação

### Navegação Simples

```dart
context.push(PacienteHomePage.route);
```

### Navegação com Substituição

```dart
context.pushReplacement(PacienteHomePage.route);
```

### Navegação com Parâmetros

```dart
context.push(
  HistoricoPacientePage.route,
  extra: {
    'pacienteId': pacienteId,
    'nomePaciente': nomePaciente,
  },
);
```

### Navegação com Nome de Rota

```dart
context.pushNamed(
  Routes.historicoPacienteName,
  extra: {
    'pacienteId': pacienteId,
    'nomePaciente': nomePaciente,
  },
);
```

## Boas Práticas

1. **Constantes para Rotas**: Defina as rotas como constantes estáticas nas classes de página
2. **Tipagem de Parâmetros**: Use tipos fortes para parâmetros de rota quando possível
3. **Encapsulamento**: Encapsule a lógica de navegação complexa em métodos auxiliares
4. **Testes**: Teste os fluxos de navegação para garantir que o redirecionamento funcione corretamente

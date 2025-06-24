# Módulos de Features do CareFlow App

## Visão Geral

O CareFlow App é organizado em módulos de features, cada um representando uma funcionalidade específica do aplicativo. Esta abordagem facilita a manutenção, testabilidade e escalabilidade do código. Cada módulo de feature é autocontido, com seus próprios componentes de UI, controladores e lógica de negócios.

## Estrutura de uma Feature

Cada feature segue uma estrutura semelhante:

```
features/
└── nome_da_feature/
    ├── nome_da_feature_page.dart       # Página principal
    ├── nome_da_feature_controller.dart # Controlador
    ├── widgets/                        # Widgets específicos da feature
    │   ├── widget_1.dart
    │   └── widget_2.dart
    └── subfeatures/                    # Subfeatures (quando aplicável)
        └── subfeature/
            ├── subfeature_page.dart
            └── subfeature_controller.dart
```

## Módulos Principais

### 1. Auth

O módulo de autenticação gerencia o registro e login de usuários.

#### Componentes Principais:

- **LoginPage**: Página de login para pacientes e profissionais
- **SignUpPage**: Página de registro com fluxos separados para pacientes e profissionais

#### Fluxo de Autenticação:

1. O usuário escolhe entre login e registro
2. Se for registro, escolhe entre paciente e profissional
3. Preenche os dados necessários
4. É redirecionado para a página principal correspondente ao seu tipo

### 2. Paciente

O módulo de paciente contém as funcionalidades específicas para usuários do tipo paciente.

#### Componentes Principais:

- **PacienteHomePage**: Página inicial do paciente
- **PacienteMainPage**: Shell que contém a estrutura comum para todas as páginas do paciente
- **HistoricoPacientePage**: Exibe o histórico médico do paciente

#### Exemplo de Implementação - HistoricoPacientePage:

```dart
class HistoricoPacientePage extends StatelessWidget {
  final String pacienteId;
  final String nomePaciente;

  const HistoricoPacientePage({
    super.key,
    required this.pacienteId,
    required this.nomePaciente,
  });

  static const String route = '/paciente/historico';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoricoPacienteController(
        Provider.of<PacienteProvider>(context, listen: false),
      )..carregarHistoricoPaciente(
        pacienteId: pacienteId,
      ),
      child: _HistoricoPacienteView(
        pacienteId: pacienteId,
        nomePaciente: nomePaciente,
      ),
    );
  }
}
```

### 3. Profissional

O módulo de profissional contém as funcionalidades específicas para usuários do tipo profissional de saúde.

#### Componentes Principais:

- **ProfissionalHomePage**: Página inicial do profissional
- **ProfissionalMainPage**: Shell que contém a estrutura comum para todas as páginas do profissional
- **ProfissionalAgendamentosPage**: Gerencia os agendamentos do profissional
- **ProfissionalRoadmapPage**: Exibe o roadmap de consultas do profissional
- **ProfissionalPerfilPublicoPage**: Exibe o perfil público do profissional para pacientes

### 4. Consultas

O módulo de consultas gerencia o agendamento e acompanhamento de consultas entre pacientes e profissionais.

#### Componentes Principais:

- **PacientesAgendamentosPage**: Permite que pacientes agendem consultas com profissionais
- **ConsultaDetalhesPage**: Exibe detalhes de uma consulta específica

### 5. Perfil

O módulo de perfil gerencia as informações de perfil tanto para pacientes quanto para profissionais.

#### Componentes Principais:

- **PerfilPage**: Página de perfil compartilhada, que exibe conteúdo diferente com base no tipo de usuário
- **PerfilController**: Controlador que gerencia a lógica de perfil para ambos os tipos de usuário

## Padrão de Implementação

### Padrão Page-Controller

Cada feature segue o padrão Page-Controller:

1. **Page**: Componente StatelessWidget que configura os providers e renderiza a View
2. **Controller**: Classe ChangeNotifier que gerencia o estado e a lógica de negócios
3. **View**: Componente StatelessWidget (geralmente privado) que renderiza a UI com base no estado do controller

```dart
// Page
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeatureController(...),
      child: _FeatureView(),
    );
  }
}

// Controller
class FeatureController extends ChangeNotifier {
  // Estado e lógica
}

// View
class _FeatureView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FeatureController>();
    // Renderiza UI com base no estado do controller
  }
}
```

### Gerenciamento de Estado

O estado de cada feature é gerenciado pelo seu controller, que estende ChangeNotifier. Os widgets observam o controller usando `context.watch<Controller>()` e são reconstruídos quando o estado muda.

### Padrão de UI State

Muitas features utilizam um enum para representar os diferentes estados da UI:

```dart
enum FeatureUiState {
  loading,
  error,
  empty,
  content
}

class FeatureController extends ChangeNotifier {
  FeatureUiState get uiState {
    if (_isLoading) return FeatureUiState.loading;
    if (_error != null) return FeatureUiState.error;
    if (_data == null || _data.isEmpty) return FeatureUiState.empty;
    return FeatureUiState.content;
  }
}
```

A view então renderiza diferentes widgets com base no estado atual:

```dart
Widget build(BuildContext context) {
  final controller = context.watch<FeatureController>();
  
  switch (controller.uiState) {
    case FeatureUiState.loading:
      return LoadingWidget();
    case FeatureUiState.error:
      return ErrorWidget(message: controller.errorMessage);
    case FeatureUiState.empty:
      return EmptyStateWidget();
    case FeatureUiState.content:
      return ContentWidget(data: controller.data);
  }
}
```

## Comunicação entre Features

As features se comunicam através de:

1. **Providers Globais**: Compartilham estado entre diferentes features
2. **Navegação**: Passam parâmetros durante a navegação
3. **Eventos**: Notificam outras features sobre mudanças importantes

## Boas Práticas

1. **Coesão**: Cada feature deve ser coesa e focar em uma funcionalidade específica
2. **Baixo Acoplamento**: Minimize as dependências entre features
3. **Reutilização**: Extraia componentes comuns para widgets compartilhados
4. **Testabilidade**: Mantenha a lógica de negócios no controller para facilitar os testes
5. **Consistência**: Siga o mesmo padrão em todas as features

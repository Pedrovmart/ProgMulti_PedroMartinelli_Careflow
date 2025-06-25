# Componentes Core do CareFlow App

## Visão Geral

O diretório `core` contém componentes fundamentais que são utilizados em todo o aplicativo. Estes componentes formam a base da arquitetura do CareFlow App e são essenciais para o funcionamento correto do sistema.

## Estrutura do Diretório Core

```
core/
├── http/          # Configuração e serviços HTTP
├── providers/     # Providers globais
├── repositories/  # Repositórios de acesso a dados
├── services/      # Serviços externos
├── ui/            # Componentes de UI compartilhados
└── utils/         # Utilitários e helpers
```

## HTTP

O diretório `http` contém classes para configuração e gerenciamento de requisições HTTP. Estas classes são responsáveis por encapsular a lógica de comunicação com APIs externas.

### HttpClient

A classe `HttpClient` é uma abstração sobre o cliente HTTP padrão do Dart, adicionando funcionalidades como:

- Interceptação de requisições e respostas
- Tratamento padronizado de erros
- Configuração de cabeçalhos padrão
- Timeout configurável

## Providers

O diretório `providers` contém os providers globais que gerenciam o estado da aplicação. Estes providers são registrados na raiz da árvore de widgets e estão disponíveis em toda a aplicação.

### AuthProvider

O `AuthProvider` gerencia o estado de autenticação do usuário, incluindo:

- Login e registro de usuários
- Verificação do tipo de usuário (paciente ou profissional)
- Logout
- Estado de inicialização da autenticação

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  firebase_auth.User? _currentUser;
  String _userType = '';
  bool _initialized = false;

  // Getters e métodos...
}
```

### PacienteProvider

O `PacienteProvider` gerencia os dados relacionados aos pacientes, incluindo:

- Carregamento de dados do paciente atual
- Acesso ao histórico médico
- Gerenciamento de consultas do paciente

### ProfissionalProvider

O `ProfissionalProvider` gerencia os dados relacionados aos profissionais de saúde, incluindo:

- Carregamento de dados do profissional atual
- Listagem de profissionais disponíveis
- Gerenciamento de horários disponíveis

### ConsultasProvider

O `ConsultasProvider` gerencia os dados relacionados às consultas, incluindo:

- Agendamento de consultas
- Cancelamento de consultas
- Listagem de consultas por paciente ou profissional
- Atualização do status de consultas

## Repositories

O diretório `repositories` contém classes que encapsulam a lógica de acesso a dados. Estas classes são responsáveis por abstrair a fonte de dados (Firebase, Supabase, etc.) e fornecer uma interface consistente para os providers.

### AuthRepository

O `AuthRepository` encapsula a lógica de autenticação, incluindo:

- Login e registro de usuários
- Verificação do tipo de usuário
- Logout

```dart
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // Métodos de autenticação...
}
```

### PacienteRepository

O `PacienteRepository` encapsula a lógica de acesso aos dados de pacientes, incluindo:

- Busca de dados do paciente por ID
- Atualização de dados do paciente
- Acesso ao histórico médico

### ProfissionalRepository

O `ProfissionalRepository` encapsula a lógica de acesso aos dados de profissionais, incluindo:

- Busca de dados do profissional por ID
- Atualização de dados do profissional
- Listagem de profissionais por especialidade

### N8nProfissionalRepository

O `N8nProfissionalRepository` é uma implementação específica do `ProfissionalRepository` que utiliza o serviço N8n para acessar dados de profissionais.

### ConsultasRepository

O `ConsultasRepository` encapsula a lógica de acesso aos dados de consultas, incluindo:

- Criação de consultas
- Atualização de consultas
- Listagem de consultas por paciente ou profissional

## Services

O diretório `services` contém classes que encapsulam a lógica de comunicação com serviços externos. Estas classes são responsáveis por abstrair os detalhes de implementação dos serviços e fornecer uma interface consistente para os repositories.

### SupabaseService

O `SupabaseService` encapsula a lógica de comunicação com o Supabase, incluindo:

- Inicialização do cliente Supabase
- Inserção de dados de profissionais

```dart
class SupabaseService {
  static bool _initialized = false;
  static late final SupabaseClient _client;
  
  static Future<void> initializeGlobally() async {
    // Inicialização do cliente Supabase...
  }
  
  Future<void> insertProfissional({
    required String nome,
    required String email,
    required String especialidade,
    required String numRegistro,
    required String firebaseUid,
  }) async {
    // Inserção de dados no Supabase...
  }
}
```

### FirebaseService

O `FirebaseService` encapsula a lógica de comunicação com o Firebase, incluindo:

- Inicialização do Firebase
- Configuração de regras de segurança
- Funções utilitárias para acesso ao Firestore e Storage

## UI

O diretório `ui` contém componentes de UI compartilhados que são utilizados em todo o aplicativo. Estes componentes ajudam a manter a consistência visual e a reutilizar código.

### AppColors

A classe `AppColors` define as cores utilizadas em todo o aplicativo:

```dart
sealed class AppColors {
  static const Color primaryDark = Color(0xFF011936);
  static const Color primary = Color(0xFF465362);
  static const Color accent = Color(0xFF82A3A1);
  static const Color success = Color(0xFF9FC490);
  static const Color light = Color(0xFFC0DFA1);
  
  static const Color primaryLight =  Color(0xFFC0DFA1);
  static const Color accentLight = Color(0xFFA8C0BE);
  static const Color accentDark = Color(0xFF5E7A78);
  static const Color successLight = Color(0xFFC0D9B5);
  static const Color successDark = Color(0xFF7AA669);
  static const Color lightDark = Color(0xFFABC98F);
}
```

### AppTextStyles

A classe `AppTextStyles` define os estilos de texto utilizados em todo o aplicativo:

```dart
sealed class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );
  
  // Outros estilos de texto...
}
```

### AppTheme

A classe `AppTheme` define o tema geral do aplicativo, incluindo:

- Cores primárias e secundárias
- Estilos de texto
- Estilos de botões e inputs
- Decorações padrão

## Utils

O diretório `utils` contém funções utilitárias e helpers que são utilizados em todo o aplicativo. Estas funções ajudam a simplificar tarefas comuns e evitar duplicação de código.

### DateUtils

A classe `DateUtils` contém funções para manipulação de datas:

```dart
class DateUtils {
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  // Outras funções de data...
}
```

### StringUtils

A classe `StringUtils` contém funções para manipulação de strings:

```dart
class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
  
  // Outras funções de string...
}
```

### ValidationUtils

A classe `ValidationUtils` contém funções para validação de dados:

```dart
class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  // Outras funções de validação...
}
```

## Dependency Injection

A classe `DependencyInjection` é responsável por configurar e fornecer instâncias de dependências para o aplicativo:

```dart
class DependencyInjection {
  static final N8nProfissionalRepository profissionalRepository = N8nProfissionalRepository();
  
  // Outras dependências...
  
  static Future<void> initialize() async {
    // Inicialização de dependências...
  }
}
```

## Boas Práticas

1. **Separação de Responsabilidades**: Cada componente do diretório `core` tem uma responsabilidade bem definida
2. **Abstração**: Os repositories e services abstraem os detalhes de implementação dos serviços externos
3. **Reutilização**: Os componentes de UI e funções utilitárias são reutilizados em todo o aplicativo
4. **Consistência**: Os componentes seguem padrões consistentes de nomenclatura e estrutura
5. **Testabilidade**: Os componentes são projetados para serem facilmente testáveis

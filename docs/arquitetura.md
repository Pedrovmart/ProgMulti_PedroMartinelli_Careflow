# Arquitetura do CareFlow App

## Visão Geral da Arquitetura

O CareFlow App segue os princípios da Clean Architecture, organizando o código em camadas com responsabilidades bem definidas. A estrutura do projeto é organizada por features, facilitando a manutenção e escalabilidade do código.

## Camadas da Arquitetura

### 1. Apresentação (UI)
- **Widgets**: Componentes de interface do usuário
- **Pages**: Telas completas da aplicação
- **Controllers**: Gerenciam o estado e a lógica de apresentação

### 2. Domínio
- **Models**: Representações dos objetos de negócio
- **Providers**: Gerenciam o estado global da aplicação

### 3. Dados
- **Repositories**: Abstraem o acesso aos dados
- **Services**: Implementam a comunicação com serviços externos

## Organização do Projeto

```
lib/
├── app/
│   ├── core/                  # Componentes centrais reutilizáveis
│   │   ├── http/              # Configuração de clientes HTTP
│   │   ├── providers/         # Providers globais
│   │   ├── repositories/      # Repositórios de dados
│   │   ├── services/          # Serviços externos (Firebase, Supabase)
│   │   ├── ui/                # Componentes de UI compartilhados
│   │   └── utils/             # Utilitários e helpers
│   ├── features/              # Módulos organizados por funcionalidade
│   │   ├── auth/              # Autenticação (login, cadastro)
│   │   ├── consultas/         # Gerenciamento de consultas
│   │   ├── paciente/          # Funcionalidades específicas do paciente
│   │   ├── perfil/            # Gerenciamento de perfil
│   │   └── profissional/      # Funcionalidades específicas do profissional
│   ├── models/                # Modelos de dados
│   ├── routes/                # Configuração de rotas
│   └── widgets/               # Widgets compartilhados
```

## Fluxo de Dados

1. **UI (Pages/Widgets)** - Exibe dados e captura interações do usuário
2. **Controllers** - Processam eventos e atualizam o estado
3. **Providers** - Gerenciam o estado global e comunicam-se com repositórios
4. **Repositories** - Abstraem a fonte de dados (local ou remota)
5. **Services** - Comunicam-se com APIs externas (Firebase, Supabase)

## Injeção de Dependências

O projeto utiliza o padrão Provider para injeção de dependências. As dependências são registradas na classe `App` e disponibilizadas para os widgets através do `MultiProvider`.

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ProfissionalProvider()),
    // Outros providers...
  ],
  child: Consumer<AuthProvider>(
    builder: (context, authProvider, _) {
      return MaterialApp.router(
        // Configuração do app...
      );
    },
  ),
)
```

## Gerenciamento de Estado

O aplicativo utiliza o padrão Provider para gerenciamento de estado. Cada feature possui seu próprio provider que gerencia o estado específico daquela funcionalidade.

### Exemplo de Fluxo de Estado:

1. **Widget** chama um método no **Controller**
2. **Controller** atualiza seu estado interno e notifica seus ouvintes
3. **UI** é reconstruída com base no novo estado

## Padrões de Design

- **Repository Pattern**: Para abstrair o acesso a dados
- **Provider Pattern**: Para gerenciamento de estado e injeção de dependências
- **Controller Pattern**: Para gerenciar a lógica de apresentação
- **Clean Architecture**: Para separação de responsabilidades

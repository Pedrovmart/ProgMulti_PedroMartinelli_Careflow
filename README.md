# CareFlow App

## Visão Geral

CareFlow é um aplicativo móvel desenvolvido em Flutter para conectar pacientes e profissionais de saúde. O aplicativo permite que pacientes encontrem profissionais de saúde, agendem consultas e acessem seu histórico médico. Profissionais de saúde podem gerenciar seus agendamentos, visualizar informações dos pacientes e acompanhar seu roadmap de atendimentos.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma
- **Firebase**: Autenticação e armazenamento de dados (Firestore)
- **Supabase**: Armazenamento adicional para dados de profissionais
- **Provider**: Gerenciamento de estado
- **Go Router**: Navegação

## Estrutura do Projeto

O projeto segue uma arquitetura limpa (Clean Architecture) organizada por features:

```
lib/
├── app/
│   ├── core/
│   │   ├── http/
│   │   ├── providers/
│   │   ├── repositories/
│   │   ├── services/
│   │   ├── ui/
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   ├── consultas/
│   │   ├── paciente/
│   │   ├── perfil/
│   │   └── profissional/
│   ├── models/
│   ├── routes/
│   └── widgets/
```

## Configuração do Ambiente

### Pré-requisitos

- Flutter SDK (versão mais recente)
- Dart SDK
- Firebase CLI
- Conta Firebase
- Conta Supabase

### Variáveis de Ambiente

O projeto utiliza um arquivo `.env` para gerenciar variáveis de ambiente. Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```
SUPABASE_URL=sua_url_do_supabase
SUPABASE_ANON_KEY=sua_chave_anon_do_supabase
```

## Documentação Detalhada

Para mais detalhes sobre a arquitetura e implementação, consulte os seguintes documentos:

- [Arquitetura](docs/arquitetura.md)
- [Autenticação](docs/autenticacao.md)
- [Navegação](docs/navegacao.md)
- [Integração Firebase](docs/firebase.md)
- [Integração Supabase](docs/supabase.md)
- [Módulos de Features](docs/features.md)
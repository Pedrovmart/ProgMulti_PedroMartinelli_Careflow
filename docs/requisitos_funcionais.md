# Requisitos Funcionais do CareFlow App

## Visão Geral

Este documento descreve os requisitos funcionais implementados no CareFlow App, uma aplicação móvel desenvolvida em Flutter que conecta pacientes e profissionais de saúde. Os requisitos estão organizados por módulo funcional e representam as capacidades atuais do sistema.

## Módulo de Autenticação

### RF001 - Registro de Pacientes
- O sistema deve permitir que novos usuários se registrem como pacientes.
- Dados necessários: nome completo, e-mail, senha, data de nascimento (opcional), telefone (opcional).
- O sistema deve validar o formato do e-mail e a força da senha.
- Após o registro bem-sucedido, o usuário deve ser redirecionado para a página inicial de pacientes.

### RF002 - Registro de Profissionais de Saúde
- O sistema deve permitir que novos usuários se registrem como profissionais de saúde.
- Dados necessários: nome completo, e-mail, senha, especialidade, número de registro profissional, data de nascimento (opcional), telefone (opcional), descrição profissional (opcional).
- O sistema deve validar o formato do e-mail, a força da senha e o formato do número de registro.
- Os dados do profissional devem ser armazenados tanto no Firebase quanto no Supabase.
- Após o registro bem-sucedido, o usuário deve ser redirecionado para a página inicial de profissionais.

### RF003 - Login de Usuários
- O sistema deve permitir que usuários registrados façam login usando e-mail e senha.
- O sistema deve identificar automaticamente o tipo de usuário (paciente ou profissional) após o login.
- O sistema deve redirecionar o usuário para a página inicial correspondente ao seu tipo.
- O sistema deve manter a sessão do usuário ativa até que ele faça logout.

### RF004 - Logout de Usuários
- O sistema deve permitir que usuários façam logout da aplicação.
- Após o logout, o usuário deve ser redirecionado para a página de login.
- O sistema deve limpar todos os dados da sessão do usuário.


## Módulo de Pacientes

### RF006 - Visualização de Perfil do Paciente
- O sistema deve permitir que pacientes visualizem e editem seu perfil.
- Informações exibidas: nome, e-mail, data de nascimento, telefone, endereço.
- O paciente deve poder atualizar suas informações pessoais.

### RF007 - Busca de Profissionais
- O sistema deve permitir que pacientes busquem profissionais de saúde.
- A busca deve poder ser filtrada por especialidade, nome ou disponibilidade.
- O sistema deve exibir uma lista de profissionais que correspondem aos critérios de busca.

### RF008 - Visualização de Perfil de Profissionais
- O sistema deve permitir que pacientes visualizem o perfil completo de profissionais de saúde.
- Informações exibidas: nome, especialidade, número de registro, descrição, horários disponíveis.

### RF009 - Agendamento de Consultas
- O sistema deve permitir que pacientes agendem consultas com profissionais de saúde.
- O paciente deve poder selecionar data e horário disponíveis.
- O sistema deve confirmar o agendamento e notificar o profissional.

### RF010 - Visualização de Consultas Agendadas
- O sistema deve permitir que pacientes visualizem suas consultas agendadas.
- Informações exibidas: nome do profissional, especialidade, data, horário, status.
- O paciente deve poder cancelar consultas agendadas com antecedência.

### RF011 - Histórico Médico
- O sistema deve permitir que pacientes visualizem seu histórico médico.
- O histórico deve incluir consultas passadas, diagnósticos e observações dos profissionais.
- O paciente deve poder filtrar o histórico por data ou profissional.

## Módulo de Profissionais

### RF012 - Visualização de Perfil do Profissional
- O sistema deve permitir que profissionais visualizem e editem seu perfil.
- Informações exibidas: nome, especialidade, número de registro, descrição, horários disponíveis.
- O profissional deve poder atualizar suas informações pessoais e profissionais.

### RF013 - Gerenciamento de Disponibilidade
- O sistema deve permitir que profissionais definam sua disponibilidade para consultas.
- O profissional deve poder especificar dias da semana e horários disponíveis.
- O sistema deve atualizar automaticamente a disponibilidade após o agendamento de consultas.

### RF014 - Visualização de Consultas Agendadas
- O sistema deve permitir que profissionais visualizem suas consultas agendadas.
- Informações exibidas: nome do paciente, data, horário, status.
- O profissional deve poder cancelar consultas agendadas com antecedência.

### RF015 - Roadmap de Consultas
- O sistema deve fornecer um roadmap visual das consultas do profissional.
- O roadmap deve exibir consultas organizadas por data e horário.
- O profissional deve poder navegar entre diferentes períodos (dia, semana, mês).

### RF016 - Registro de Observações
- O sistema deve permitir que profissionais registrem observações após as consultas.
- As observações devem ser associadas ao histórico médico do paciente.
- O profissional deve poder visualizar observações anteriores do mesmo paciente.

## Módulo de Consultas

### RF017 - Criação de Consultas
- O sistema deve permitir a criação de consultas entre pacientes e profissionais.
- Dados necessários: ID do paciente, ID do profissional, data, horário.
- O sistema deve validar a disponibilidade do profissional antes de confirmar a consulta.

### RF018 - Atualização de Status de Consultas
- O sistema deve permitir a atualização do status de consultas.
- Status possíveis: pendente, confirmada, concluída, cancelada.
- O sistema deve notificar ambas as partes sobre mudanças de status.

### RF019 - Cancelamento de Consultas
- O sistema deve permitir o cancelamento de consultas por ambas as partes.
- O cancelamento deve ser permitido até um período definido antes da consulta.
- O sistema deve liberar o horário para novos agendamentos após o cancelamento.

### RF020 - Histórico de Consultas
- O sistema deve manter um histórico de todas as consultas realizadas.
- O histórico deve incluir informações como data, horário, paciente, profissional e observações.
- O sistema deve permitir a busca no histórico por diferentes critérios.

## Módulo de Notificações

### RF021 - Notificações de Consultas
- O sistema deve enviar notificações sobre consultas agendadas.
- Notificações devem ser enviadas para lembrar sobre consultas próximas.
- O sistema deve notificar sobre cancelamentos ou alterações em consultas.

### RF022 - Preferências de Notificação
- O sistema deve permitir que usuários configurem suas preferências de notificação.
- Opções incluem: notificações por e-mail, notificações push, frequência de lembretes.

## Requisitos Não-Funcionais

### RNF001 - Segurança
- O sistema deve armazenar senhas de forma segura utilizando algoritmos de hash.
- O acesso aos dados deve ser controlado por regras de segurança do Firebase.
- A comunicação com os servidores deve ser criptografada (HTTPS).

### RNF002 - Desempenho
- O sistema deve carregar a página inicial em menos de 3 segundos.
- As operações de busca devem retornar resultados em menos de 2 segundos.
- O sistema deve suportar pelo menos 1000 usuários simultâneos.

### RNF003 - Usabilidade
- A interface deve ser intuitiva e seguir as diretrizes de design do Material Design.
- O sistema deve ser acessível para usuários com deficiências visuais.
- O sistema deve ser responsivo e funcionar em diferentes tamanhos de tela.

### RNF004 - Disponibilidade
- O sistema deve estar disponível 24/7, com tempo de inatividade planejado não superior a 4 horas por mês.
- O sistema deve ter um mecanismo de backup diário dos dados.

### RNF005 - Compatibilidade
- O aplicativo deve ser compatível com Android 6.0+ e iOS 12.0+.
- O sistema deve funcionar corretamente em diferentes dispositivos e resoluções de tela.

## Matriz de Rastreabilidade

| ID     | Módulo        | Componentes Relacionados                                   |
|--------|---------------|-----------------------------------------------------------|
| RF001  | Autenticação  | AuthProvider, AuthRepository, SignUpPage                   |
| RF002  | Autenticação  | AuthProvider, AuthRepository, SupabaseService, SignUpPage  |
| RF003  | Autenticação  | AuthProvider, AuthRepository, LoginPage                    |
| RF004  | Autenticação  | AuthProvider, AuthRepository, PerfilPage                   |
| RF005  | Autenticação  | AuthProvider, AuthRepository, RecuperarSenhaPage           |
| RF006  | Paciente      | PacienteProvider, PacienteRepository, PerfilPage           |
| RF007  | Paciente      | ProfissionalProvider, ProfissionalRepository, BuscaPage    |
| RF008  | Paciente      | ProfissionalProvider, ProfissionalPerfilPublicoPage        |
| RF009  | Paciente      | ConsultasProvider, ConsultasRepository, AgendamentoPage    |
| RF010  | Paciente      | ConsultasProvider, ConsultasRepository, ConsultasPage      |
| RF011  | Paciente      | PacienteProvider, PacienteRepository, HistoricoPacientePage|
| RF012  | Profissional  | ProfissionalProvider, ProfissionalRepository, PerfilPage   |
| RF013  | Profissional  | ProfissionalProvider, DisponibilidadePage                  |
| RF014  | Profissional  | ConsultasProvider, ConsultasRepository, ConsultasPage      |
| RF015  | Profissional  | ConsultasProvider, ProfissionalRoadmapPage                 |
| RF016  | Profissional  | ConsultasProvider, ObservacoesPage                         |
| RF017  | Consultas     | ConsultasProvider, ConsultasRepository                     |
| RF018  | Consultas     | ConsultasProvider, ConsultasRepository                     |
| RF019  | Consultas     | ConsultasProvider, ConsultasRepository                     |
| RF020  | Consultas     | ConsultasProvider, ConsultasRepository                     |
| RF021  | Notificações  | NotificacoesProvider, NotificacoesService                  |
| RF022  | Notificações  | NotificacoesProvider, PreferenciasPage                     |

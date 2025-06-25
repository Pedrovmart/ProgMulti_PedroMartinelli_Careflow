# Integração com Supabase no CareFlow App

## Visão Geral

O CareFlow App utiliza o Supabase como banco de dados complementar ao Firebase, especificamente para armazenar dados de profissionais de saúde. Esta integração permite aproveitar recursos específicos do Supabase para determinadas funcionalidades do aplicativo.

## Configuração

### Variáveis de Ambiente

A conexão com o Supabase é configurada através de variáveis de ambiente definidas no arquivo `.env`:

```
SUPABASE_URL=sua_url_do_supabase
SUPABASE_ANON_KEY=sua_chave_anon_do_supabase
```

### Inicialização

O serviço Supabase é inicializado globalmente no início da aplicação:

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

## Serviço Supabase

A classe `SupabaseService` encapsula a lógica de comunicação com o Supabase:

```dart
class SupabaseService {
  static bool _initialized = false;
  static late final SupabaseClient _client;
  
  static Future<void> initializeGlobally() async {
    if (_initialized) return;
    
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('Supabase environment variables not found');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true,
      );
      
      _client = Supabase.instance.client;
      _initialized = true;
      log('Supabase inicializado com sucesso');
    } catch (e) {
      log('Erro ao inicializar Supabase: $e');
      rethrow;
    }
  }
  
  Future<void> initialize() async {
    if (!_initialized) {
      await initializeGlobally();
    }
  }

  // Métodos para operações no Supabase
}
```

## Armazenamento de Dados de Profissionais

O Supabase é utilizado para armazenar dados de profissionais de saúde, complementando o armazenamento no Firebase:

```dart
Future<void> insertProfissional({
  required String nome,
  required String email,
  required String especialidade,
  required String numRegistro,
  required String firebaseUid,
}) async {
  if (!_initialized) {
    await initialize();
  }

  try {
    log('Inserindo profissional no Supabase: $nome, $email');
    final response = await _client.from('profissionais').insert({
      'nome': nome,
      'email': email,
      'especialidade': especialidade,
      'num_registro': numRegistro,
      'firebase_uid': firebaseUid,
    }).select();
    log('Profissional inserido com sucesso no Supabase: $response');
  } catch (e) {
    log('Erro ao inserir profissional no Supabase: $e');
    throw Exception('Falha ao inserir profissional no Supabase: ${e.toString()}');
  }
}
```

## Integração com o Processo de Registro

A integração com o Supabase é utilizada durante o processo de registro de profissionais:

```dart
Future<User?> registerProfissional(
  String email,
  String password,
  String name,
  String especialidade,
  String numRegistro, 
) async {
  try {
    await _supabaseService.initialize();
    
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user?.updateDisplayName(name);
    
    final uid = userCredential.user!.uid;
    
    // Armazenamento no Firebase
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc('profissionais')
        .collection('profissionais')
        .doc(uid)
        .set({
          'nome': name,
          'email': email,
          'especialidade': especialidade,
          'numRegistro': numRegistro,
          'userType': 'profissional',
          'createdAt': FieldValue.serverTimestamp(),
        });
    
    // Armazenamento no Supabase
    await _supabaseService.insertProfissional(
      nome: name,
      email: email,
      especialidade: especialidade,
      numRegistro: numRegistro,
      firebaseUid: uid,
    );
    
    return userCredential.user;
  } catch (e) {
    log('Erro ao registrar profissional: ${e.toString()}');
    throw Exception("Falha ao registrar profissional: ${e.toString()}");
  }
}
```

## Estrutura da Tabela no Supabase

A tabela `profissionais` no Supabase tem a seguinte estrutura:

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | uuid | Chave primária gerada automaticamente |
| nome | text | Nome do profissional |
| email | text | Email do profissional |
| especialidade | text | Especialidade médica |
| num_registro | text | Número de registro profissional |
| firebase_uid | text | ID do usuário no Firebase (chave estrangeira) |
| created_at | timestamp | Data de criação do registro |

## Casos de Uso

### Registro de Profissional

1. O usuário preenche o formulário de registro como profissional
2. Os dados são validados
3. Uma conta é criada no Firebase Authentication
4. Os dados do profissional são armazenados no Firestore
5. Os mesmos dados são armazenados no Supabase para uso em funcionalidades específicas

### Consultas Avançadas

O Supabase pode ser utilizado para consultas mais complexas que seriam difíceis de implementar no Firestore, como:

- Busca de profissionais por especialidade com filtros avançados
- Análises e estatísticas sobre profissionais
- Integrações com serviços externos que se conectam ao PostgreSQL

## Boas Práticas

1. **Sincronização**: Mantenha os dados sincronizados entre Firebase e Supabase
2. **Tratamento de Erros**: Implemente tratamento de erros adequado para falhas na comunicação com o Supabase
3. **Segurança**: Configure regras de segurança no Supabase para proteger os dados
4. **Monitoramento**: Monitore o desempenho das consultas ao Supabase
5. **Backup**: Implemente estratégias de backup para os dados no Supabase

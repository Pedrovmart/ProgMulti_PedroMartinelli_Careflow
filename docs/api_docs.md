# Geração de Documentação API para o CareFlow App

## Visão Geral

Este documento descreve como gerar e manter a documentação de API para o CareFlow App usando o dartdoc, a ferramenta oficial de documentação do Dart. A documentação de API fornece uma referência técnica detalhada de todas as classes, métodos e propriedades do projeto, facilitando o entendimento e a manutenção do código.

## Pré-requisitos

- Dart SDK instalado e configurado
- Flutter SDK instalado e configurado
- Projeto CareFlow App clonado localmente

## Instalação do dartdoc

O dartdoc é uma ferramenta que vem com o Dart SDK, mas também pode ser ativada globalmente para facilitar o uso:

```bash
dart pub global activate dartdoc
```

## Preparação do Projeto

Para obter uma documentação de API de qualidade, é importante seguir algumas práticas recomendadas:

1. **Adicionar comentários de documentação**: Adicionar comentários de documentação (/// ou /** */) a classes, métodos e propriedades.

   ```dart
   /// Representa um usuário profissional de saúde no sistema.
   /// 
   /// Contém informações específicas de profissionais como especialidade
   /// e número de registro profissional.
   class Profissional extends UserModel {
     // ...
   }
   ```

2. **Incluir exemplos de uso**: Adicionar exemplos de uso em comentários de documentação.

   ```dart
   /// Retorna uma lista de consultas para o profissional especificado.
   /// 
   /// Exemplo:
   /// ```dart
   /// final consultas = await getConsultasProfissional('prof123');
   /// for (var consulta in consultas) {
   ///   print(consulta.nomePaciente);
   /// }
   /// ```
   Future<List<Consulta>> getConsultasProfissional(String profissionalId) async {
     // ...
   }
   ```

3. **Documentar parâmetros e retornos**: Documentar parâmetros e valores de retorno.

   ```dart
   /// Registra um novo profissional no sistema.
   /// 
   /// [nome] O nome completo do profissional.
   /// [email] O endereço de e-mail do profissional.
   /// [senha] A senha escolhida pelo profissional.
   /// [especialidade] A especialidade médica do profissional.
   /// [numeroRegistro] O número de registro profissional.
   /// 
   /// Retorna o ID do usuário criado.
   /// 
   /// Lança [FirebaseAuthException] se o registro falhar.
   Future<String> registerProfissional({
     required String nome,
     required String email,
     required String senha,
     required String especialidade,
     required String numeroRegistro,
   }) async {
     // ...
   }
   ```

## Geração da Documentação

Para gerar a documentação de API, siga os seguintes passos:

1. Navegue até o diretório raiz do projeto:

   ```bash
   cd caminho/para/careflow_app
   ```

2. Execute o comando dartdoc:

   ```bash
   dart doc
   ```

   Ou, se preferir usar a versão global:

   ```bash
   dart pub global run dartdoc
   ```

3. Aguarde a conclusão do processo. A documentação será gerada no diretório `doc/api/`.

## Visualização da Documentação

Para visualizar a documentação gerada, você pode:

1. Abrir o arquivo `doc/api/index.html` em um navegador web.

2. Ou usar o servidor integrado do dartdoc:

   ```bash
   dart pub global run dartdoc --serve
   ```

   Isso iniciará um servidor local na porta 8080, e você poderá acessar a documentação em `http://localhost:8080`.

## Solução de Problemas Comuns

### Documentação Vazia ou Incompleta

Se a documentação gerada estiver vazia ou incompleta, verifique:

1. **Problemas de análise**: Execute `dart analyze` para verificar se há erros no código que possam estar impedindo a geração da documentação.

2. **Exclusões**: Verifique se há arquivos ou diretórios excluídos no arquivo `dartdoc_options.yaml`.

3. **Visibilidade**: Certifique-se de que as classes e métodos que você deseja documentar sejam públicos (não começam com `_`).

### Erros de Geração

Se ocorrerem erros durante a geração da documentação:

1. **Dependências**: Certifique-se de que todas as dependências estão atualizadas com `flutter pub get`.

2. **Versão do Dart**: Verifique se você está usando uma versão compatível do Dart SDK.

3. **Memória**: Se o projeto for grande, aumente a memória disponível para o dartdoc:

   ```bash
   dart --old_gen_heap_size=2048 pub global run dartdoc
   ```

## Personalização da Documentação

Você pode personalizar a geração da documentação criando um arquivo `dartdoc_options.yaml` na raiz do projeto:

```yaml
dartdoc:
  categories:
    "Core":
      - app/core
    "Features":
      - app/features
    "Models":
      - app/models
  categoryOrder: ["Core", "Features", "Models"]
  showUndocumentedCategories: true
  ignore:
    - broken-link
  errors:
    - unresolved-doc-reference
  warnings:
    - tool-error
```

## Integração Contínua

Para manter a documentação sempre atualizada, considere integrar a geração de documentação ao seu fluxo de CI/CD:

```yaml
# Exemplo para GitHub Actions
name: Generate Docs

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: dart-lang/setup-dart@v1
    - name: Install dependencies
      run: dart pub get
    - name: Generate documentation
      run: dart doc
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./doc/api
```

## Boas Práticas

1. **Atualize a documentação regularmente**: Mantenha a documentação atualizada à medida que o código evolui.

2. **Documente interfaces públicas**: Priorize a documentação de APIs públicas e interfaces que outros desenvolvedores usarão.

3. **Seja consistente**: Mantenha um estilo consistente em toda a documentação.

4. **Inclua exemplos**: Exemplos práticos ajudam muito na compreensão do código.

5. **Verifique links quebrados**: Use a opção `--validate-links` para verificar links quebrados na documentação.

## Recursos Adicionais

- [Documentação oficial do dartdoc](https://dart.dev/tools/dartdoc)
- [Guia de estilo de documentação do Dart](https://dart.dev/guides/language/effective-dart/documentation)
- [Exemplos de documentação do Flutter](https://api.flutter.dev/)

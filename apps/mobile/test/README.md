# GHub Mobile - Testing Guide

## 📋 Visão Geral

Este projeto implementa uma suíte completa de testes unitários seguindo as melhores práticas para aplicações Flutter com Clean Architecture e Riverpod.

## 🏗️ Estrutura de Testes

```
test/
├── helpers/
│   └── test_helpers.dart          # Helpers e mocks compartilhados
├── setup/
│   └── test_setup.dart           # Configuração global dos testes
├── core/
│   ├── error/
│   └── network/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   ├── data/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       └── providers/
│   ├── games/
│   ├── onboarding/
│   ├── profile/
│   └── achievements/
├── all_tests.dart                # Runner para todos os testes
└── scripts/
    └── run_tests.sh             # Script utilitário
```

## 🧪 Tipos de Testes Implementados

### 1. Testes de Entidades
- Validação de criação de objetos
- Serialização/Deserialização JSON
- Igualdade e comparação de objetos
- Métodos de cópia (copyWith)

### 2. Testes de Casos de Uso
- Validação de parâmetros de entrada
- Fluxo de execução correto
- Tratamento de erros e exceções
- Interação com repositories

### 3. Testes de Repositórios
- Implementação da interface de domínio
- Coordenação entre data sources locais e remotos
- Mapeamento de exceções para failures
- Cache e sincronização de dados

### 4. Testes de Providers (Riverpod)
- Estado inicial dos providers
- Mudanças de estado em resposta a ações
- Tratamento de estados de loading e erro
- Override de dependências para testes

### 5. Testes de Serviços Core
- Verificação de conectividade de rede
- Tratamento de exceções e failures
- Configurações de API e constantes

## 🚀 Executando os Testes

### Comandos Básicos

```bash
# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage

# Executar testes de uma feature específica
flutter test test/features/auth/

# Executar teste específico
flutter test test/features/auth/domain/usecases/login_with_credentials_test.dart
```

### Usando o Script Utilitário

```bash
# Executar todos os testes com setup automático
./scripts/run_tests.sh

# Executar com relatório de cobertura
./scripts/run_tests.sh --coverage

# Executar testes por feature
./scripts/run_tests.sh --auth
./scripts/run_tests.sh --games
./scripts/run_tests.sh --core

# Ver ajuda
./scripts/run_tests.sh --help
```

## 🛠️ Configuração e Dependências

### Dependências de Teste
- `flutter_test`: Framework de testes do Flutter
- `mockito`: Criação de mocks
- `build_runner`: Geração de código para mocks

### Configuração Inicial
```bash
# Instalar dependências
flutter pub get

# Gerar mocks (necessário após mudanças nas interfaces)
dart run build_runner build --delete-conflicting-outputs
```

## 📝 Padrões e Convenções

### Estrutura de um Teste
```dart
void main() {
  late ClassUnderTest classUnderTest;
  late MockDependency mockDependency;

  setUp(() {
    mockDependency = MockDependency();
    classUnderTest = ClassUnderTest(mockDependency);
  });

  group('ClassUnderTest', () {
    test('should do something when condition is met', () async {
      // arrange
      when(mockDependency.method()).thenReturn(expectedResult);

      // act
      final result = await classUnderTest.performAction();

      // assert
      expect(result, expectedResult);
      verify(mockDependency.method());
    });
  });
}
```

### Nomenclatura
- **Arquivos**: `<class_name>_test.dart`
- **Classes Mock**: `Mock<ClassName>`
- **Grupos**: Nome da classe ou feature sendo testada
- **Testes**: Descrição clara do comportamento esperado

### Fixtures de Teste
Use a classe `TestFixtures` em `test_helpers.dart` para dados consistentes:

```dart
// Usar dados padrão dos fixtures
final user = User.fromJson(TestFixtures.userJson);
const email = TestFixtures.validEmail;
```

## 📊 Cobertura de Testes

### Metas de Cobertura
- **Entities**: 100% - Classes simples com lógica de serialização
- **Use Cases**: 100% - Regras de negócio críticas
- **Repositories**: 90%+ - Lógica de coordenação de dados
- **Providers**: 85%+ - Gerenciamento de estado
- **Core Services**: 90%+ - Serviços fundamentais

### Verificando Cobertura
```bash
# Gerar relatório de cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Abrir relatório no navegador
open coverage/html/index.html
```

## 🔧 Mocking e Test Doubles

### Criando Mocks
```dart
// 1. Importar mockito annotations
import 'package:mockito/annotations.dart';

// 2. Declarar mocks
@GenerateMocks([AuthRepository, NetworkInfo])
import 'auth_repository_impl_test.mocks.dart';

// 3. Usar nos testes
late MockAuthRepository mockRepository;
```

### Provider Overrides
```dart
// Para testar providers Riverpod
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(mockRepository),
  ],
);
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Mocks não encontrados**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Testes falham por dependências**
   - Verificar se todos os providers necessários estão sendo mockados
   - Usar `TestFixtures` para dados consistentes

3. **Testes assíncronos não funcionam**
   - Usar `async/await` adequadamente
   - Aguardar futures com `thenAnswer((_) async => ...)`

4. **Estado compartilhado entre testes**
   - Sempre usar `setUp()` para inicializar mocks
   - Resetar estado global quando necessário

## 📚 Recursos Adicionais

- [Flutter Testing Documentation](https://flutter.dev/docs/cookbook/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Riverpod Testing Guide](https://riverpod.dev/docs/cookbooks/testing)
- [Clean Architecture Testing Patterns](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 🎯 Próximos Passos

1. **Widget Tests**: Implementar testes de UI
2. **Integration Tests**: Testes end-to-end
3. **Golden Tests**: Testes visuais de componentes
4. **Performance Tests**: Benchmarks de uso de memória e CPU
5. **CI/CD**: Automação de testes no pipeline
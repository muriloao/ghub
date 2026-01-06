# Configuração do Projeto GHub

## 📋 Pré-requisitos

Antes de executar o projeto, certifique-se de ter:

1. **Flutter SDK** instalado (versão 3.10.4 ou superior)
2. **Android Studio** ou **VS Code** com extensões Flutter/Dart
3. **Device/Emulador** Android ou iOS configurado

## 🚀 Configuração Inicial

### 1. Instalação das Dependências

```bash
cd /Users/muriloao/development/workspace/murilo/ghub/apps/mobile
flutter pub get
```

### 2. Geração de Código

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Configuração do Google Sign In

#### Para Android:

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Crie um novo projeto chamado "GHub"
3. Adicione um aplicativo Android com o package name: `br.com.muriloao.ghub`
4. Baixe o arquivo `google-services.json`
5. Coloque o arquivo em: `android/app/google-services.json`

6. Adicione no `android/build.gradle.kts`:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}
```

7. Adicione no `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

8. Configure o SHA1 fingerprint:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Copie o SHA1 e adicione no Firebase Console.

#### Para iOS:

1. No Firebase Console, adicione um aplicativo iOS
2. Use o Bundle ID: `br.com.muriloao.ghub`
3. Baixe o `GoogleService-Info.plist`
4. Abra `ios/Runner.xcworkspace` no Xcode
5. Arraste o arquivo `GoogleService-Info.plist` para o projeto

## 🔧 Comandos de Desenvolvimento

### Executar o aplicativo:
```bash
flutter run
```

### Debug no dispositivo específico:
```bash
flutter devices  # Lista dispositivos disponíveis
flutter run -d <device_id>
```

### Build para produção:
```bash
flutter build apk  # Android
flutter build ios  # iOS
```

### Testes:
```bash
flutter test
```

### Análise de código:
```bash
flutter analyze
```

## 🐛 Troubleshooting

### Para compilar
```bash
--dart-define-from-file=.env
```

--dart-define-from-file=.env

### Erro: "Some Android licenses not accepted"
```bash
flutter doctor --android-licenses
```

### Erro na geração de código:
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Problemas com dependências:
```bash
flutter clean
flutter pub get
```

## 📱 Testando a Funcionalidade

### Login com Credenciais:
- Email: Qualquer email válido
- Senha: Mínimo 6 caracteres
- A validação é feita em tempo real

### Login com Google:
- Requer configuração do Firebase
- Testa a integração com Google Sign In

## 🎨 Funcionalidades Implementadas

✅ **Estrutura Clean Architecture**
- Separação clara de camadas (Domain, Data, Presentation)
- Injeção de dependências com Riverpod
- Repository Pattern

✅ **Feature de Autenticação**
- Login com email/senha
- Login social com Google
- Validação de formulários
- Armazenamento seguro de tokens
- Gerenciamento de estado reativo

✅ **UI/UX**
- Interface baseada no design fornecido
- Tema dark/light responsivo
- Animações e transições suaves
- Formulários com validação visual

✅ **Navegação**
- GoRouter para navegação declarativa
- Rotas protegidas por autenticação

✅ **Tratamento de Erros**
- Sistema unificado de erros
- Feedback visual para o usuário
- Logs estruturados

## 📂 Estrutura do Projeto

```
lib/
├── core/                    # Configurações globais
├── features/auth/           # Feature de autenticação
│   ├── data/               # Datasources, Models, Repositories
│   ├── domain/             # Entities, Use Cases
│   └── presentation/       # UI, State Management
└── shared/                 # Componentes reutilizáveis
```

## 🔄 Próximos Passos

Para expandir o projeto:
1. Adicionar novas features seguindo a mesma estrutura
2. Implementar testes unitários e de widget
3. Configurar CI/CD
4. Adicionar métricas e analytics
5. Implementar push notifications

## 🆘 Suporte

Se encontrar problemas:
1. Verifique se todas as dependências estão instaladas
2. Execute `flutter doctor` para diagnosticar problemas
3. Consulte a documentação oficial do Flutter
4. Verifique os logs do dispositivo/emulador
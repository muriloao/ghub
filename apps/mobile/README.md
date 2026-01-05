# GHub Mobile App

Um aplicativo móvel para sincronização de estatísticas de jogos, desenvolvido com Flutter seguindo Clean Architecture e as melhores práticas.

## 🏗️ Arquitetura

O projeto segue a **Clean Architecture** com as seguintes camadas:

```
lib/
├── core/                     # Configurações globais
│   ├── constants/           # Constantes da aplicação
│   ├── error/               # Gerenciamento de erros
│   ├── network/             # Configurações de rede
│   ├── router/              # Navegação da aplicação
│   ├── theme/               # Tema e design system
│   └── utils/               # Utilitários
├── features/                # Features da aplicação
│   └── auth/               # Feature de autenticação
│       ├── data/           # Camada de dados
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/         # Camada de domínio
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/   # Camada de apresentação
│           ├── pages/
│           ├── providers/
│           └── widgets/
└── shared/                 # Widgets compartilhados
    └── widgets/
```

## 🚀 Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento
- **Riverpod** - Gerenciamento de estado
- **Dio** - Cliente HTTP
- **GoRouter** - Navegação
- **Google Sign In** - Autenticação social
- **Freezed** - Geração de código para data classes
- **Json Serializable** - Serialização JSON
- **Shared Preferences & Secure Storage** - Armazenamento local

## 📦 Instalação

1. Clone o repositório:
```bash
git clone [repository-url]
cd ghub/apps/mobile
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute a geração de código:
```bash
dart run build_runner build
```

4. Configure o Google Sign In:

### Android
1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Crie um novo projeto ou use um existente
3. Adicione um aplicativo Android
4. Baixe o `google-services.json` e coloque em `android/app/`
5. Configure o SHA1 fingerprint:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### iOS
1. No Firebase Console, adicione um aplicativo iOS
2. Baixe o `GoogleService-Info.plist` e adicione ao projeto Xcode
3. Configure as URL schemes no `ios/Runner/Info.plist`

## 🎨 Features Implementadas

### ✅ Autenticação
- [x] Login com email e senha
- [x] Login com Google
- [x] Validação de formulários
- [x] Gerenciamento de estado com Riverpod
- [x] Armazenamento seguro de tokens
- [x] Interface responsiva baseada no design fornecido

### 🔄 Próximas Features
- [ ] Cadastro de usuário
- [ ] Recuperação de senha  
- [ ] Dashboard principal
- [ ] Perfil do usuário
- [ ] Sincronização de estatísticas

## 🎯 Como Usar

1. Execute o aplicativo:
```bash
flutter run
```

2. Na tela de login:
   - Digite email e senha para login tradicional
   - Ou clique no botão Google para autenticação social
   - Validações são aplicadas automaticamente

3. Após o login bem-sucedido, você será redirecionado para a tela principal

## 🏛️ Padrões Implementados

### Clean Architecture
- **Entities**: Objetos de negócio puros
- **Use Cases**: Regras de negócio da aplicação  
- **Repositories**: Contratos para acesso a dados
- **Data Sources**: Implementações concretas de acesso

### Design Patterns
- **Repository Pattern**: Abstração da camada de dados
- **Provider Pattern**: Injeção de dependências com Riverpod
- **MVVM**: Model-View-ViewModel com StateNotifier
- **Factory Pattern**: Criação de objetos complexos

### Boas Práticas
- **Separation of Concerns**: Separação clara de responsabilidades
- **Dependency Injection**: Inversão de dependências
- **Error Handling**: Tratamento consistente de erros
- **Code Generation**: Automação com build_runner
- **Type Safety**: Uso extensivo de tipos seguros

## 🔧 Comandos Úteis

```bash
# Instalar dependências
flutter pub get

# Gerar código
dart run build_runner build

# Limpar cache de build
dart run build_runner clean

# Executar testes
flutter test

# Análise de código
flutter analyze

# Formatar código
dart format .

# Verificar dependências desatualizadas
flutter pub outdated
```

## 📱 Screenshots

A interface foi desenvolvida baseada no design fornecido em `ux/auth/code.html`, incluindo:

- Header com gradiente e logo animado
- Formulários com validação em tempo real
- Botões sociais com animações
- Tema dark/light responsivo
- Design system consistente

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença [MIT](LICENSE).

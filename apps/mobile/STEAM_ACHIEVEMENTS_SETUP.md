# Exemplo de Configuração para Steam Achievements

## 1. Configurar Steam API Key

### 1.1 Obter Steam Web API Key
1. Acesse https://steamcommunity.com/dev/apikey
2. Faça login com sua conta Steam
3. Registre um domínio (pode usar `localhost` para testes)
4. Copie sua Steam Web API Key

### 1.2 Configurar no App
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String steamApiKey = 'SUA_STEAM_API_KEY_AQUI';
  static const String steamApiBaseUrl = 'http://api.steampowered.com';
}
```

### 1.3 Configurar no Arquivo .env (Recomendado)
```env
# .env
STEAM_API_KEY=SUA_STEAM_API_KEY_AQUI
```

```dart
// Usar com flutter_dotenv
await dotenv.load(fileName: ".env");
final steamApiKey = dotenv.env['STEAM_API_KEY']!;
```

## 2. Exemplos de Jogos Populares para Teste

### Jogos com muitos achievements:
- **Cyberpunk 2077**: App ID `1091500`
- **The Witcher 3**: App ID `292030`
- **Elden Ring**: App ID `1245620`
- **GTA V**: App ID `271590`
- **Red Dead Redemption 2**: App ID `1174180`
- **Stardew Valley**: App ID `413150`
- **Terraria**: App ID `105600`

### Exemplo de Steam IDs para teste (públicos):
- `76561198000000000` (exemplo genérico)
- Para obter seu Steam ID: https://steamidfinder.com/

## 3. Como Testar no Desenvolvimento

### 3.1 Configurar um usuário de teste
```dart
// Em um provider ou service de desenvolvimento
class DevTestData {
  static const String testSteamId = '76561198000000000';
  static const String testGameAppId = '413150'; // Stardew Valley
}
```

### 3.2 Criar um mock service para desenvolvimento
```dart
class MockSteamGamesService extends SteamGamesService {
  @override
  Future<List<CompleteSteamAchievementModel>> getCompleteAchievements(
    String steamId,
    String appId,
  ) async {
    // Retornar dados mockados para desenvolvimento
    return _getMockAchievements();
  }
}
```

### 3.3 Testar com dados reais
```dart
void testRealSteamAPI() async {
  final service = SteamGamesService();
  
  try {
    final achievements = await service.getCompleteAchievements(
      'SEU_STEAM_ID',
      '413150', // Stardew Valley
    );
    
    print('Total de achievements: ${achievements.length}');
    for (final achievement in achievements.take(5)) {
      print('${achievement.name}: ${achievement.isUnlocked ? "✅" : "❌"}');
    }
  } catch (e) {
    print('Erro ao buscar achievements: $e');
  }
}
```

## 4. Como Obter Steam ID do Usuário

### 4.1 Steam Login (OpenID)
Para implementação completa, você precisaria integrar com Steam OpenID:

```dart
// Exemplo conceitual - Steam OpenID integration
class SteamAuth {
  static Future<String?> loginWithSteam() async {
    // Implementar Steam OpenID flow
    // Retorna Steam ID do usuário logado
  }
}
```

### 4.2 Para testes, usar Steam ID fixo
```dart
class UserService {
  // Para desenvolvimento/teste
  static const String debugSteamId = '76561198000000000';
  
  String getCurrentUserSteamId() {
    // Em produção: retornar Steam ID do usuário logado
    // Em desenvolvimento: retornar Steam ID de teste
    return debugSteamId;
  }
}
```

## 5. Estrutura de Teste da UI

### 5.1 Testar com GameDetailPage
```dart
// Em uma página de teste ou desenvolvimento
Widget buildTestPage() {
  return Scaffold(
    appBar: AppBar(title: Text('Teste Steam Achievements')),
    body: GameDetailPage(
      game: SteamGameModel(
        appId: '413150',
        name: 'Stardew Valley',
        shortDescription: 'Você herdou a antiga fazenda de seu avô...',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/413150/header.jpg',
        website: '',
        developers: ['ConcernedApe'],
        publishers: ['ConcernedApe'],
        platforms: SteamPlatforms(windows: true, mac: true, linux: true),
        metacritic: SteamMetacritic(score: 89),
        categories: [],
        genres: [],
        screenshots: [],
        releaseDate: SteamReleaseDate(comingSoon: false, date: 'Feb 26, 2016'),
        priceOverview: null,
      ),
    ),
  );
}
```

### 5.2 Testar apenas a seção de achievements
```dart
Widget buildAchievementsTest() {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Steam Achievements Test')),
      body: GameAchievementsSection(
        appId: '413150',
        gameName: 'Stardew Valley',
      ),
    ),
  );
}
```

## 6. Depuração e Logs

### 6.1 Adicionar logs detalhados
```dart
class SteamGamesService {
  final Logger _logger = Logger('SteamGamesService');
  
  Future<List<CompleteSteamAchievementModel>> getCompleteAchievements(
    String steamId,
    String appId,
  ) async {
    _logger.info('Buscando achievements para user $steamId, game $appId');
    
    try {
      // ... implementação
      _logger.info('Achievements encontrados: ${achievements.length}');
      return achievements;
    } catch (e) {
      _logger.severe('Erro ao buscar achievements: $e');
      rethrow;
    }
  }
}
```

### 6.2 Monitorar estado dos providers
```dart
// Em development mode
Consumer(
  builder: (context, ref, child) {
    final achievementsState = ref.watch(gameAchievementsProvider('413150'));
    
    return Column(
      children: [
        Text('Estado: ${achievementsState.runtimeType}'),
        if (achievementsState is AsyncError)
          Text('Erro: ${achievementsState.error}'),
        // ... resto da UI
      ],
    );
  },
)
```

## 7. Checklist de Teste

- [ ] Steam API Key configurada
- [ ] Dependency cached_network_image adicionada
- [ ] Build runner executado (`dart run build_runner build`)
- [ ] Provider scope configurado na main.dart
- [ ] Steam ID de teste definido
- [ ] Game App IDs válidos para teste
- [ ] UI renderizando sem erros
- [ ] Filtros funcionando (All/Rare)
- [ ] Estatísticas calculando corretamente
- [ ] Imagens dos achievements carregando
- [ ] Estados de loading/error tratados

## 8. Próximos Passos

1. **Implementar autenticação Steam real** (Steam OpenID)
2. **Cache de achievements** no storage local
3. **Sincronização em background** dos achievements
4. **Notificações** para novos achievements desbloqueados
5. **Comparação** de achievements entre amigos
6. **Achievement showcase** no perfil do usuário
7. **Pesquisa e filtros avançados** de achievements

## Exemplo Completo de Uso

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Em qualquer página
class TestSteamAchievements extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Steam Achievements')),
      body: GameAchievementsSection(
        appId: '413150', // Stardew Valley
        gameName: 'Stardew Valley',
      ),
    );
  }
}
```

Para começar a testar, configure sua Steam API Key e use um dos App IDs sugeridos!
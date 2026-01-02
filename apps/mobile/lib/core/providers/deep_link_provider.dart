import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/deep_link_service.dart';

/// Provider para o serviço de deep linking
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService();
});

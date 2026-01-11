import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/integrations/data/services/platforms_api_service.dart';

class TestApiIntegrationPage extends ConsumerWidget {
  const TestApiIntegrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(platformsApiServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API Integration'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await apiService.getAvailablePlatforms();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Success! Found ${response.platforms.length} platforms',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  print(
                    'API Response: ${response.platforms.length} platforms found',
                  );
                  for (final platform in response.platforms) {
                    print('- ${platform.displayName}: ${platform.description}');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  print('API Error: $e');
                }
              },
              child: const Text('Test API Connection'),
            ),
            const SizedBox(height: 16),
            const Text(
              'This button tests the connection to the platforms API endpoint.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

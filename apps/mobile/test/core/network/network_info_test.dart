import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:ghub_mobile/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@GenerateMocks([Connectivity])
import 'network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('NetworkInfo', () {
    test('should return true when device is connected to wifi', () async {
      // arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
      verify(mockConnectivity.checkConnectivity());
    });

    test('should return true when device is connected to mobile', () async {
      // arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
      verify(mockConnectivity.checkConnectivity());
    });

    test('should return true when device is connected to ethernet', () async {
      // arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
      verify(mockConnectivity.checkConnectivity());
    });

    test('should return false when device has no connection', () async {
      // arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
      verify(mockConnectivity.checkConnectivity());
    });

    test('should return true when device has multiple connections', () async {
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
      );

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
      verify(mockConnectivity.checkConnectivity());
    });

    test(
      'should return false when connectivity result contains only none',
      () async {
        // arrange
        when(mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.none, ConnectivityResult.none],
        );

        // act
        final result = await networkInfo.isConnected;

        // assert
        expect(result, false);
        verify(mockConnectivity.checkConnectivity());
      },
    );
  });
}

// test/titanpark_api_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'package:titanpark/services/titanpark_api.dart';
import 'package:titanpark/config.dart';

void main() {
  group('TitanParkApi', () {
    test('uses kParkingApiBaseUrl as baseUrl', () {
      final api = TitanParkApi();

      // 1) baseUrl should match config.dart
      expect(api.baseUrl, equals(kParkingApiBaseUrl));

      // 2) The getListings endpoint should be constructed correctly
      final expectedUrl = '$kParkingApiBaseUrl/get_listings';
      final actualUrl = '${api.baseUrl}/get_listings';

      expect(actualUrl, equals(expectedUrl));
    });
  });
}

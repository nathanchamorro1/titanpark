// test/titanpark_api_parse_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TitanParkApi Listing Parsing', () {
    test('parses listings map keyed by ID into a list of maps', () {
      final mockJson = {
        '1': {
          'user_id': 'abc',
          'structure_name': 'Nutwood Parking Structure',
          'price': 25,
          'floor': 3,
          'vehicle': {
            'make': 'Honda',
            'model': 'Civic',
            'license_plate': 'ABC123',
          },
        },
        '2': {
          'user_id': 'def',
          'structure_name': 'Eastside North',
          'price': 30,
          'floor': 2,
          'vehicle': null,
        },
      };

      final parsed = <Map<String, dynamic>>[];

      mockJson.forEach((idKey, value) {
        final data = value as Map<String, dynamic>;

        final userId = data['user_id']?.toString() ?? '';
        final rawName = (data['structure_name'] ?? '').toString();
        final nameUpper = rawName.toUpperCase();

        int structureId;
        if (nameUpper.contains('NUTWOOD')) {
          structureId = 1;
        } else if (nameUpper.contains('STATE COLLEGE')) {
          structureId = 2;
        } else if (nameUpper.contains('EASTSIDE NORTH')) {
          structureId = 3;
        } else if (nameUpper.contains('EASTSIDE SOUTH')) {
          structureId = 4;
        } else {
          structureId = 0;
        }

        final vehicle = data['vehicle'] as Map<String, dynamic>?;
        final vehicleSummary = vehicle == null
            ? ''
            : '${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''} '
              '(${vehicle['license_plate'] ?? ''})';

        parsed.add({
          'id': int.parse(idKey),
          'userId': userId,
          'structureId': structureId,
          'floor': data['floor'] as int,
          'price': (data['price'] as num).toDouble(),
          'vehicleSummary': vehicleSummary,
        });
      });

      expect(parsed.length, 2);

      expect(parsed[0]['id'], 1);
      expect(parsed[0]['userId'], 'abc');
      expect(parsed[0]['structureId'], 1);
      expect(parsed[0]['vehicleSummary'], 'Honda Civic (ABC123)');

      expect(parsed[1]['id'], 2);
      expect(parsed[1]['userId'], 'def');
      expect(parsed[1]['structureId'], 3); // Eastside North
      expect(parsed[1]['vehicleSummary'], '');
    });
  });
}

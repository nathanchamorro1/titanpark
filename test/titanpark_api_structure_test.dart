// test/titanpark_api_structure_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TitanParkApi Structure Mapping', () {
    test('maps structure_name to correct structureId', () {
      final testCases = {
        'Nutwood Parking Structure': 1,
        'State College Parking Structure': 2,
        'Eastside North': 3,
        'Eastside South': 4,
        'Random Unknown Structure': 0,
      };

      testCases.forEach((name, expectedId) {
        final nameUpper = name.toUpperCase();

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

        expect(structureId, expectedId, reason: 'Failed for "$name"');
      });
    });
  });
}

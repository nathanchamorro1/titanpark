// lib/services/titanpark_api.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // required for debugPrint
import 'package:http/http.dart' as http;

import '../models/listing.dart';
import '../config.dart';

class TitanParkApi {
  final String baseUrl = kParkingApiBaseUrl;

  Future<List<Listing>> getListings() async {
    final response = await http.get(Uri.parse('$baseUrl/get_listings'));

    if (response.statusCode != 200) {
      throw Exception('Error trying to get listings: ${response.body}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      final List<Listing> listings = [];

      decoded.forEach((idKey, value) {
        final data = value as Map<String, dynamic>;

        // user_id is a string
        final userId = data['user_id']?.toString() ?? '';

        final rawName =
            (data['structure_name'] ?? data['structure'] ?? '').toString();

        // Normalize for matching
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
          // Fall back if backend doesn’t send a recognizable name
          structureId = 0;
        }

        final vehicle = data['vehicle'] as Map<String, dynamic>?;

        final vehicleSummary = vehicle == null
            ? ''
            : '${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''} (${vehicle['license_plate'] ?? ''})';

        listings.add(
          Listing(
            id: int.tryParse(idKey) ?? 0,
            userId: userId,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            structureId: structureId,
            floor: (data['floor'] as int?) ?? 0,
            vehicleId: vehicleSummary,
            comment: data['comment'] as String?,
          ),
        );
      });

      return listings;
    }

    // If JSON structure is unexpected, return empty list
    return [];
  }

  /// Call /add_vehicle and return the vehicle's ID (UUID as String).
  Future<String> addVehicle({
    required String userId,
    required String make,
    required String model,
    required int year,
    required String color,
    required String licensePlate,
  }) async {
    final uri = Uri.parse('$baseUrl/add_vehicle').replace(
      queryParameters: {
        'user_id': userId,
        'make': make,
        'model': model,
        'year': year.toString(),
        'color': color,
        'license_plate': licensePlate,
      },
    );

    if (kDebugMode) debugPrint('ADD VEHICLE REQUEST → $uri');

    final response = await http.post(uri);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add vehicle: ${response.body}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      // Backend returns {"vehicle_uuid": "..."}
      final vehicleUuid = decoded['vehicle_uuid'] ?? decoded['id'];
      if (vehicleUuid != null) {
        return vehicleUuid as String;
      }
    }

    throw Exception('Unexpected add_vehicle response: ${response.body}');
  }

  Future<void> addListing({
    required String userId,
    required int price,
    required int structureId,
    required int floor,
    required String vehicleId,
    required String comment,
  }) async {
    final uri = Uri.parse('$baseUrl/add_listing').replace(
      queryParameters: {
        'user_id': userId,
        'price': price.toString(),
        'structure_id': structureId.toString(),
        'floor': floor.toString(),
        'vehicle_id': vehicleId,
        'comment': comment,
      },
    );

    final response = await http.post(uri);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add listing: ${response.body}');
    }
  }
}

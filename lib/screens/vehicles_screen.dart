import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config.dart';
import 'package:http/http.dart' as http;
import './add_vehicle_screen.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreen();
}

class _VehiclesScreen extends State<VehiclesScreen> {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await http.get(
        Uri.parse('$kParkingApiBaseUrl/get_user_vehicles')
            .replace(queryParameters: {'user_id': userID}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _vehicles = List<Map<String, dynamic>>.from(data.entries.map((entry) {
            final vehicleData = Map<String, dynamic>.from(entry.value as Map);
            vehicleData['id'] = entry.key;
            return vehicleData;
          }));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load vehicles: ${res.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error trying to get your vehicles. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteVehicle(String vehicleID) async {
    setState(() {
      _isLoading = true;
    });

    final params = {
      'vehicle_id': vehicleID,
    };

    final res = await http.post(
      Uri.parse('$kParkingApiBaseUrl/delete_vehicle')
          .replace(queryParameters: params),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to delete vehicle: ${res.body}');
    }

    setState(() {
      _isLoading = false;
    });
    _fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchVehicles,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _vehicles[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        child: Icon(
                          Icons.directions_car,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        '${vehicle['year']} ${vehicle['make']} ${vehicle['model']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text('License Plate: ${vehicle['license_plate']}'),
                          Text('Color: ${vehicle['color']}')
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteVehicle(vehicle['id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVehicleScreen(),
            ),
          );
          _fetchVehicles();
        },
        tooltip: 'Add vehicle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

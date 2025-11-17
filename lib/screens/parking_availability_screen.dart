import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ParkingAvailabilityScreen extends StatefulWidget {
  final http.Client? httpClient;

  const ParkingAvailabilityScreen({super.key, this.httpClient});

  @override
  State<ParkingAvailabilityScreen> createState() =>
      _ParkingAvailabilityScreen();
}

class _ParkingAvailabilityScreen extends State<ParkingAvailabilityScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _data = [];
  String? _errorMessage;
  late final http.Client _httpClient;

  @override
  void initState() {
    super.initState();
    _httpClient = widget.httpClient ?? http.Client();
    _fetchStructures();
  }

  @override
  void dispose() {
    if (widget.httpClient == null) {
      _httpClient.close();
    }
    super.dispose();
  }

  Future<void> _fetchStructures() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _httpClient.get(
        Uri.parse('$kParkingApiBaseUrl/parking_data/all'),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        setState(() {
          _isLoading = false;
          _data = List<Map<String, dynamic>>.from(data.values);
        });
      } else {
        throw Exception(
            'Failed to load parking availability data: ${res.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'There was an error loading parking structure data';
      });
    }
  }

  Color _getAvailabilityColor(double percFull) {
    if (percFull < 0.5) {
      return Colors.green;
    } else if (percFull < 0.75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getAvailabilityText(double percFull) {
    if (percFull < 0.5) {
      return 'Low Traffic';
    } else if (percFull < 0.75) {
      return 'Moderate Traffic';
    } else {
      return 'High Traffic';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Availability'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchStructures,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchStructures,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchStructures,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _data.length,
                    itemBuilder: (context, idx) {
                      final structure = _data[idx];
                      final structName = structure['name'];

                      // ------------ FIXED PERCENTAGE HERE ------------
                      final double raw = (structure['perc_full'] as num).toDouble(); // ex: 47.8
                      final double percFull = raw / 100; // used for progress indicator (0.0–1.0)
                      // -------------------------------------------------

                      final available = structure['available'] as int;
                      final total = structure['total'] as int;
                      final taken = total - available;
                      final numFormatter = NumberFormat('#,##0');
                      final spotsForSaleCount = 0;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //   Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      structName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    key: Key('parking_indicator'),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getAvailabilityColor(percFull)
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getAvailabilityColor(percFull),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      _getAvailabilityText(percFull),
                                      style: TextStyle(
                                        color: _getAvailabilityColor(percFull),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),

                              //   Availability bar
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${numFormatter.format(available)} spots available',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              _getAvailabilityColor(percFull),
                                        ),
                                      ),
                                      Text(
                                        key: const Key('perc_full'),
                                        '${raw.toStringAsFixed(1)}% Full',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: percFull,
                                      backgroundColor: Colors.grey[200],
                                      color: _getAvailabilityColor(percFull),
                                      minHeight: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${numFormatter.format(taken)} / ${numFormatter.format(total)} spots taken',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Spots for sale count
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${numFormatter.format(spotsForSaleCount)} spots for sale',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: spotsForSaleCount > 0
                                        ? () {
                                            throw UnimplementedError();
                                          }
                                        : null,
                                    icon: const Icon(Icons.local_parking,
                                        size: 12),
                                    label: const Text('Park here'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

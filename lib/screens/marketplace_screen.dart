import 'package:flutter/material.dart';
import '../models/listing.dart'; 
import 'package:titanpark/services/titanpark_api.dart';

String structureNameFromId(int id) {
  switch (id) {
    case 1:
      return 'Nutwood Parking Structure';
    case 2:
      return 'State College Parking Structure';
    case 3:
      return 'Eastside North Parking Structure';
    case 4:
      return 'Eastside South Parking Structure';
    default:
      return 'Structure $id';
  }
}

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});


  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TitanParkApi _api = TitanParkApi();
  final TextEditingController _searchController = TextEditingController();

  List<Listing> _allListings = [];
  List<Listing> _filteredListings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  Future<void> _loadListings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final listings = await _api.getListings();
      setState(() {
        _allListings = listings;
        _filteredListings = listings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _runSearch(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filteredListings = _allListings.where((listing) {
        final comment = (listing.comment ?? '').toLowerCase();
        final idText = listing.id.toString();
        final priceText = listing.price.toString();

        return comment.contains(q) ||
            idText.contains(q) ||
            priceText.contains(q);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadListings,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: open filter modal
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search parking spots...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _runSearch,
            ),
          ),

          // Listing Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error: $_error'))
                    : _filteredListings.isEmpty
                        ? const Center(
                            child: Text('Sorry, there are no listings available. Please try again later.'),
                          )
                        : ListView.builder(
                            itemCount: _filteredListings.length,
                            itemBuilder: (context, index) {
                              final listing = _filteredListings[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.local_parking,
                                    size: 36,
                                  ),
                                  title: Text(
                                    structureNameFromId(listing.structureId),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Floor ${listing.floor} • ${listing.price.toInt()} credits\n'
                                    'Vehicle: ${listing.vehicleId}'
                                    '${listing.comment != null && listing.comment!.isNotEmpty ? '\n${listing.comment}' : ''}',
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    // TODO: navigate to detail screen with listing.id
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

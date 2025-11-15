import 'package:flutter/material.dart';
import 'package:titanpark/services/titanpark_api.dart';


class ListSpotScreen extends StatefulWidget {
  const ListSpotScreen({super.key});

  @override
  State<ListSpotScreen> createState() => _ListSpotScreenState();
}

class _ListSpotScreenState extends State<ListSpotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TitanParkApi _api = TitanParkApi();


// Structure controllers
  String _selectedStructure = 'EASTSIDE NORTH PARKING STRUCTURE';
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _creditsController =
      TextEditingController(text: '25');
  final TextEditingController _locationController = TextEditingController();
  // Car details controllers
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();

  TimeOfDay? _selectedTime;

  int _structureId() {
    switch (_selectedStructure) {
      case 'EASTSIDE NORTH PARKING STRUCTURE':
        return 3;
      case 'EASTSIDE SOUTH PARKING STRUCTURE':
        return 4;
      case 'NUTWOOD PARKING STRUCTURE':
        return 1;
      case 'STATE COLLEGE PARKING STRUCTURE':
        return 2;
      default:
        return 0;
    }
  }

  String _structureImage() {
  switch (_selectedStructure) {
    case 'EASTSIDE NORTH PARKING STRUCTURE':
      return 'assets/maps/eastside_north.png';
    case 'EASTSIDE SOUTH PARKING STRUCTURE':
      return 'assets/maps/eastside_south.png';
    case 'NUTWOOD PARKING STRUCTURE':
      return 'assets/maps/nutwood.png';
    case 'STATE COLLEGE PARKING STRUCTURE':
      return 'assets/maps/state_college.png';
    default:
      return 'assets/titanpark_map_placeholder.png';
  }
}

  @override
  void dispose() {
    _floorController.dispose();
    _timeController.dispose();
    _creditsController.dispose();
    _locationController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  final structureId = _structureId();
  final floor = int.parse(_floorController.text);
  final price = int.parse(_creditsController.text);

  // TODO: later wire this to real logged-in user
  const String userId = 'demo-user';

  final locText = _locationController.text.trim();
  final timeText = _timeController.text.trim();

  final comment = [
    if (timeText.isNotEmpty) 'Leaves at $timeText',
    if (locText.isNotEmpty) 'Location: $locText',
  ].join('. ');

  try {
    final vehicleId = await _api.addVehicle(
      userId: userId,
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text),
      color: _colorController.text.trim(),
      licensePlate: _licensePlateController.text.trim(),
    );

    await _api.addListing(
      userId: userId,
      price: price,
      structureId: structureId,
      floor: floor,
      vehicleId: vehicleId,
      comment: comment,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Listing created successfully.')),
    );
    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create listing: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('List a Spot'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'List a Spot',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Structure dropdown
                  Text(
                    'Parking Structure',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedStructure,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'EASTSIDE NORTH PARKING STRUCTURE',
                        child: Text('Eastside North Parking Structure'),
                      ),
                      DropdownMenuItem(
                        value: 'EASTSIDE SOUTH PARKING STRUCTURE',
                        child: Text('Eastside South Parking Structure'),
                      ),
                      DropdownMenuItem(
                        value: 'NUTWOOD PARKING STRUCTURE',
                        child: Text('Nutwood Parking Structure'),
                      ),
                      DropdownMenuItem(
                        value: 'STATE COLLEGE PARKING STRUCTURE',
                        child: Text('State College Parking Structure'),
                      ),
                      
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedStructure = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Floor input
                  Text(
                    'Floor',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _floorController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '3',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a floor';
                      }
                      final num? parsed = int.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid floor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Map preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        _structureImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // When do you plan to leave? (time picker)
                  Text(
                    'When do you plan to leave?',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: _pickTime,
                    decoration: InputDecoration(
                      hintText: '11:00 AM',
                      suffixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please choose a time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Credits (you already have this)
                  Text(
                    'How many credits would you like to list your parking spot for?',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _creditsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    decoration: InputDecoration(
                      suffixText: 'credits',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price in credits';
                      }
                      final num? parsed = num.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),

                  // Recommendation text (already there)
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'We recommend '),
                        TextSpan(
                          text: '20 credits ',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'due to current trends and the time.',
                        ),
                      ],
                    ),
                    style: theme.textTheme.bodySmall,
                  ),

                  const SizedBox(height: 24),

                  // 🔹 CAR DETAILS SECTION
                  Text(
                    'Car details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _makeController,
                    decoration: InputDecoration(
                      labelText: 'Make',
                      hintText: 'Toyota',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the car make';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: 'Model',
                      hintText: 'Camry',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the car model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      hintText: '2020',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the year';
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed < 1990 || parsed > DateTime.now().year + 1) {
                        return 'Enter a valid year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: 'Color',
                      hintText: 'Black',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _licensePlateController,
                    decoration: InputDecoration(
                      labelText: 'License plate',
                      hintText: 'ABC1234',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the license plate';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // (Then your existing location description section if you still want it)


// Location description widget
Text(
  'What is your license plate, and where in the structure is your car parked?',
  style: theme.textTheme.labelLarge,
),
Text(
  'Include details that will help the buyer easily find your car inside the structure. '
  'For example: the level, the direction you\'re facing, nearby signs or landmarks, and optionally your license plate.',
  style: theme.textTheme.bodySmall?.copyWith(
    color: Colors.grey.shade500,
    height: 1.3,
  ),
),
SizedBox(height: 8),
TextFormField(
  controller: _locationController,
  maxLines: 2,
  decoration: InputDecoration(
    hintText: 'E.g., Northmost row, near elevator. Facing large red truck. License plate: ABC1234',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  ),
),
const SizedBox(height: 16),

                  // List button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'LIST',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

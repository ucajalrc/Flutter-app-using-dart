import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Using false to match the classic look in your screenshot
      ),
      home: const ConverterScreen(),
    );
  }
}

/// The main stateful widget that handles the UI and conversion logic.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Controller to retrieve text from the input field
  final TextEditingController _valueController = TextEditingController();

  // State variables for the dropdowns
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  String _resultMessage = '';

  // List of available units for the dropdowns
  final List<String> _units = [
    'Meters',
    'Kilometers',
    'Feet',
    'Miles',
    'Kilograms',
    'Pounds',
  ];

  // Map to define conversion factors relative to a base unit.
  // We use:
  // - Meters as base for Distance
  // - Kilograms as base for Weight
  final Map<String, double> _conversionFactors = {
    'Meters': 1.0,
    'Kilometers': 1000.0,
    'Feet': 0.3048,
    'Miles': 1609.34,
    'Kilograms': 1.0,
    'Pounds': 0.453592,
  };

  /// Helper map to identify the type of unit (Distance vs Weight)
  final Map<String, String> _unitTypes = {
    'Meters': 'Distance',
    'Kilometers': 'Distance',
    'Feet': 'Distance',
    'Miles': 'Distance',
    'Kilograms': 'Weight',
    'Pounds': 'Weight',
  };

  /// Main function to handle the conversion logic
  void _convert() {
    // 1. Validate Input
    if (_valueController.text.isEmpty) {
      setState(() {
        _resultMessage = 'Please enter a value';
      });
      return;
    }

    double? input = double.tryParse(_valueController.text);
    if (input == null) {
      setState(() {
        _resultMessage = 'Invalid number';
      });
      return;
    }

    // 2. Validate Compatibility (Cannot convert Weight to Distance)
    if (_unitTypes[_fromUnit] != _unitTypes[_toUnit]) {
      setState(() {
        _resultMessage = 'Cannot convert $_fromUnit to $_toUnit';
      });
      return;
    }

    // 3. Perform Conversion
    // Formula: (Input * FromFactor) / ToFactor
    // We normalize to the base unit first, then convert to the target.
    double fromFactor = _conversionFactors[_fromUnit]!;
    double toFactor = _conversionFactors[_toUnit]!;
    
    // Example: 100 Meters to Feet
    // 100 * 1.0 (base meters) / 0.3048 (feet factor) = 328.08
    double result = (input * fromFactor) / toFactor;

    // 4. Update UI
    setState(() {
      // Formatting to 3 decimal places for cleanliness
      _resultMessage = 
          "$input $_fromUnit are ${result.toStringAsFixed(3)} $_toUnit";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the standard app structure (AppBar, Body)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Prevents overflow on smaller screens
          child: Column(
            children: [
              // --- Input Value Section ---
              const Text('Value', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter value (e.g. 100)',
                  border: UnderlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              
              const SizedBox(height: 20),

              // --- "From" Dropdown Section ---
              const Text('From', style: TextStyle(fontSize: 16, color: Colors.grey)),
              DropdownButton<String>(
                value: _fromUnit,
                isExpanded: true,
                items: _units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.blue)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _fromUnit = newValue!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // --- "To" Dropdown Section ---
              const Text('To', style: TextStyle(fontSize: 16, color: Colors.grey)),
              DropdownButton<String>(
                value: _toUnit,
                isExpanded: true,
                items: _units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.blue)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _toUnit = newValue!;
                  });
                },
              ),

              const SizedBox(height: 40),

              // --- Convert Button ---
              ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.grey[300], // Background color
                   foregroundColor: Colors.black87, // Text color
                   elevation: 2,
                ),
                child: const Text('Convert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),

              // --- Result Display ---
              Text(
                _resultMessage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';
import 'package:ocevara/core/models/catch_log.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ocevara/core/services/auth_service.dart';

class AddCatchForm extends ConsumerStatefulWidget {
  final String? initialSpecies;
  final Uint8List? initialImage;
  const AddCatchForm({super.key, this.initialSpecies, this.initialImage});

  @override
  ConsumerState<AddCatchForm> createState() => _AddCatchFormState();
}

class _AddCatchFormState extends ConsumerState<AddCatchForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSpecies;
  final _quantityCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  
  // No longer using location string in model, but keeping UI field for metadata if needed
  final _locationCtrl = TextEditingController();
  
  Uint8List? _imageBytes;
  String? _imagePath; 
  final ImagePicker _picker = ImagePicker();
  final List<String> _extraSpecies = [];

  @override
  void initState() {
    super.initState();
    _selectedSpecies = widget.initialSpecies;
    _imageBytes = widget.initialImage;

    // Ensure initialSpecies is in the dropdown list to prevent assertion crash
    if (_selectedSpecies != null) {
      final baseList = CatchLogService.instance.speciesList;
      if (!baseList.contains(_selectedSpecies)) {
        if (!_extraSpecies.contains(_selectedSpecies)) {
          _extraSpecies.add(_selectedSpecies!);
        }
      }
    }
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _weightCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imagePath = photo.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  bool _isSaving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // 1. Get current position
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (e) {
        debugPrint('Error getting current location, trying last known: $e');
        try {
          position = await Geolocator.getLastKnownPosition();
        } catch (e2) {
          debugPrint('Error getting last known location: $e2');
        }
      }

      // 2. Get User ID
      final user = ref.read(userProvider);
      if (user == null) throw 'User not authenticated';

      // 3. Save Image locally
      String? savedImagePath;
      if (_imageBytes != null) {
        if (kIsWeb) {
          savedImagePath = _imagePath; // _imagePath might be null or a Blob URL on web
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final String extension = _imagePath != null ? p.extension(_imagePath!) : '.jpg';
          final String fileName =
              'catch_${DateTime.now().millisecondsSinceEpoch}$extension';
          final String savedPath = p.join(directory.path, fileName);
          
          if (_imagePath != null) {
            await io.File(_imagePath!).copy(savedPath);
          } else {
            final tempFile = io.File(savedPath);
            await tempFile.writeAsBytes(_imageBytes!);
          }
          savedImagePath = savedPath;
        }
      }

      final qty = double.tryParse(_quantityCtrl.text.trim()) ?? 0.0;
      final weight = double.tryParse(_weightCtrl.text.trim());

      final now = DateTime.now();
      final log = CatchLog(
        id: now.millisecondsSinceEpoch.toString(),
        userId: user.id,
        speciesId: _selectedSpecies ?? 'unknown', // Using species name as ID for distinct grouping
        speciesName: _selectedSpecies,
        quantity: qty,
        avgWeight: weight,
        unit: 'count', // Default
        lat: position?.latitude ?? 0.0,
        lng: position?.longitude ?? 0.0,
        date: now,
        imagePath: savedImagePath,
        synced: false,
        metadata: _locationCtrl.text.isNotEmpty ? {'location_text': _locationCtrl.text} : null,
        displayDate: '${now.day}/${now.month}/${now.year}',
        displayTime: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      );

      await ref.read(catchLogServiceProvider.notifier).addLog(log);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _addNewSpecies() async {
    // This logic should be updated in a later phase to correctly add to the Species table
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Species'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Species name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final v = ctrl.text.trim();
              if (v.isNotEmpty) Navigator.pop(context, v);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      final name = result.trim();
      setState(() {
        if (!CatchLogService.instance.speciesList.contains(name) && !_extraSpecies.contains(name)) {
          _extraSpecies.add(name);
        }
        _selectedSpecies = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseSpecies = CatchLogService.instance.speciesList;
    final allSpecies = {...baseSpecies, ..._extraSpecies}.toList()..sort();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 560),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log Today\'s Catch',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSpecies,
                          items: allSpecies
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedSpecies = v),
                          decoration: const InputDecoration(
                            labelText: 'Fish Species',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Select species'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addNewSpecies,
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF1CB5AC),
                        ),
                        tooltip: 'Add species',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _quantityCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity (number of fish)',
                      hintText: 'e.g., 25',
                      border: OutlineInputBorder(),
                      helperText: 'Enter the number of fish caught',
                    ),
                    validator: (v) =>
                        (v == null || int.tryParse(v.trim()) == null)
                        ? 'Enter quantity'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _weightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Average Weight (kg)',
                      hintText: 'e.g., 1.5',
                      border: OutlineInputBorder(),
                      helperText: 'Average weight per fish in kilograms',
                    ),
                    validator: (v) =>
                        (v == null || double.tryParse(v.trim()) == null)
                        ? 'Enter weight'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Photo Section
                  Center(
                    child: Column(
                      children: [
                        if (_imageBytes != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _imageBytes!,
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey.shade400,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No photo captured',
                                  style: GoogleFonts.lato(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _takePhoto,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Color(0xFF1CB5AC),
                          ),
                          label: Text(
                            _imageBytes == null ? 'Take Photo' : 'Retake Photo',
                            style: GoogleFonts.lato(
                              color: const Color(0xFF1CB5AC),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1CB5AC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F3950),
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Save Log',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showAddCatchDialog(
  BuildContext context, {
  String? initialSpecies,
  Uint8List? initialImage,
}) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AddCatchForm(
            initialSpecies: initialSpecies,
            initialImage: initialImage,
          ),
        ),
      ),
    ),
  );
}

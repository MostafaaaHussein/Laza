import 'package:flutter/material.dart';
import '../models/address.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';

class AddressScreen extends StatefulWidget {
  final Address? existingAddress;

  const AddressScreen({super.key, this.existingAddress});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    if (widget.existingAddress != null) {
      _populateControllers(widget.existingAddress!);
    } else {
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        try {
          final address = await _firestoreService.getAddress(uid);
          if (address != null) {
             _populateControllers(address);
          }
        } catch (e) {
          print('Error loading address: $e');
        }
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _populateControllers(Address address) {
    _nameController.text = address.fullName;
    _phoneController.text = address.phone;
    _cityController.text = address.city;
    _areaController.text = address.area;
    _streetController.text = address.street;
    _buildingController.text = address.building;
    _floorController.text = address.floor;
    _notesController.text = address.notes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final uid = _authService.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');

      final newAddress = Address(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        street: _streetController.text.trim(),
        building: _buildingController.text.trim(),
        floor: _floorController.text.trim(),
        notes: _notesController.text.trim(),
      );

      await _firestoreService.saveAddress(uid, newAddress);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving address: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _buildTextField(_nameController, 'Full Name', Icons.person_outline),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_cityController, 'City', Icons.location_city)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: _buildTextField(_areaController, 'Area', Icons.map_outlined)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(_streetController, 'Street Name', Icons.add_road),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_buildingController, 'Building', Icons.apartment)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: _buildTextField(_floorController, 'Floor', Icons.layers_outlined)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(_notesController, 'Notes (Optional)', Icons.sticky_note_2_outlined, maxLines: 3, isRequired: false),
                     const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: _isSaving ? 'Saving...' : 'Save & Continue to Payment',
                      onPressed: _isSaving ? () {} : _saveAddress,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: isRequired ? (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      } : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

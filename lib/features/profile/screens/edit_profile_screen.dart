import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/features/profile/screens/profile_screen.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/core/utils/image_utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.fullName ?? 'Austin James');
    _locationController = TextEditingController(text: 'Imo River Estuary, Nigeria');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removePhoto() {
    setState(() {
      _imageBytes = null;
    });
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    try {
      String? imageUrl;
      if (_imageBytes != null) {
        // Convert picked image to base64 data URI for immediate local persistence and UI feedback
        final base64String = base64Encode(_imageBytes!);
        imageUrl = 'data:image/jpeg;base64,$base64String';
      }

      final result = await ref.read(authServiceProvider).updateProfile(
        fullName: _nameController.text,
        profileImageUrl: imageUrl ?? ref.read(userProvider)?.profileImageUrl,
        ref: ref,
      );

      if (mounted) {
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showChangePhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Profile Photo',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF1CB5AC)),
              title: const Text('Choose from Library'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF1CB5AC)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _removePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: OcevaraAppBar(
        title: 'Edit Profile',
        actions: [
          _isLoading 
            ? const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: CircularProgressIndicator(strokeWidth: 2)))
            : TextButton(
                onPressed: _handleSave,
                child: Text(
                  'Save',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture with Change Photo
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1CB5AC), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : (user?.profileImageUrl != null 
                                  ? ImageUtils.getProfileImageProvider(user!.profileImageUrl!)
                                  : const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&h=200&auto=format&fit=crop')),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showChangePhotoOptions,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1CB5AC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showChangePhotoOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Change Profile Photo',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Edit Fields
            _buildEditField('Full Name', _nameController),
            const SizedBox(height: 24),
            _buildEditField('Location', _locationController, icon: Icons.location_on_outlined),
            
            const SizedBox(height: 40),
            
            // Impact Dashboard Section
            _buildSectionHeader('Impact Dashboard'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildImpactCard('127', 'Safe Days\nFished', Icons.calendar_today_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildImpactCard('43', 'Protected\nSpecies Aided', Icons.shield_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildImpactCard('#12', 'Community\nRank', Icons.group_outlined)),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Sustainable Catches Section
            _buildSectionHeader('Recent Sustainable Catches'),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCatchCard('Tilapia', 'Feb 18'),
                  _buildCatchCard('Catfish', 'Feb 15'),
                  _buildCatchCard('Croaker', 'Feb 12'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Utility Options List
            Container(
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildUtilityTile(Icons.anchor_outlined, 'My Fishing Gear'),
                  _buildUtilityTile(Icons.settings_outlined, 'Data & Storage Settings', isSelected: true),
                  _buildUtilityTile(Icons.menu_book_outlined, 'Local Fishing Regulations'),
                  _buildUtilityTile(Icons.workspace_premium_outlined, 'Stewardship Achievements', isLast: true),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimary(context),
        ),
      ),
    );
  }

  Widget _buildImpactCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE0FBFD),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryTeal, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatchCard(String name, String date) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE0FBFD),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.set_meal_outlined, color: AppColors.primaryTeal, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 3,
            backgroundColor: Color(0xFF1CB5AC),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityTile(IconData icon, String title, {bool isSelected = false, bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryTeal.withOpacity(0.1) : Colors.transparent,
        borderRadius: isSelected ? BorderRadius.circular(12) : null,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryNavy : (Theme.of(context).brightness == Brightness.dark ? AppColors.primaryTeal.withOpacity(0.2) : const Color(0xFFF1F4F5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : AppColors.primaryTeal, size: 20),
            ),
            title: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            onTap: () {
              if (title.contains('Achievements')) {
                 // Navigate to achievements
              }
            },
          ),
          if (!isLast && !isSelected)
            Divider(height: 1, indent: 70, color: Colors.grey.shade100),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.lato(fontSize: 16, color: AppColors.getTextPrimary(context)),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF1CB5AC)) : null,
            filled: true,
            fillColor: AppColors.getCardBackground(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1CB5AC)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}


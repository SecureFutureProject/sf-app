import 'package:flutter/material.dart';
import '../../models/business_model.dart';
import '../../services/profile_service.dart';
import '../../widgets/profile_image_picker.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';

class BusinessProfilePage extends StatefulWidget {
  final String id;

  const BusinessProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  _BusinessProfilePageState createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final ProfileService _profileService = ProfileService();
  late Future<BusinessModel?> _businessFuture;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _contactDescriptionController = TextEditingController();
  final _industryController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _nichesController = TextEditingController();
  List<String> _socialMediaLinks = [];
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    _businessFuture = _profileService.getBusinessProfile(widget.id);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactDescriptionController.dispose();
    _industryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _nichesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<BusinessModel?>(
        future: _businessFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('Business profile not found'));
          }

          final business = snapshot.data!;
          _populateFields(business);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ProfileImagePicker(
                      imageUrl: _logoUrl,
                      onTap: _handleImagePick,
                      enabled: _isEditing,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _businessNameController,
                    label: 'Business Name',
                    validator: Validators.validateName,
                  ),
                  _buildTextField(
                    controller: _contactDescriptionController,
                    label: 'Contact Description',
                    maxLines: 3,
                  ),
                  _buildTextField(
                    controller: _industryController,
                    label: 'Industry',
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                  ),
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website',
                    keyboardType: TextInputType.url,
                    validator: Validators.validateWebsite,
                  ),
                  const SizedBox(height: 16),
                  Text('Social Media Links', style: Theme.of(context).textTheme.titleMedium),
                  ..._buildSocialMediaLinks(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        enabled: _isEditing,
        validator: validator ?? (value) => value!.isEmpty ? 'This field is required' : null,
      ),
    );
  }

  List<Widget> _buildSocialMediaLinks() {
    return [
      ..._socialMediaLinks.asMap().entries.map((entry) {
        int idx = entry.key;
        String link = entry.value;
        return ListTile(
          title: Text(link),
          trailing: _isEditing ? IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _socialMediaLinks.removeAt(idx)),
          ) : null,
        );
      }),
      if (_isEditing)
        ListTile(
          title: const Text('Add Social Media Link'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSocialMediaLink,
          ),
        ),
    ];
  }

  void _addSocialMediaLink() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Social Media Link'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter link'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() => _socialMediaLinks.add(controller.text));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _populateFields(BusinessModel business) {
  _businessNameController.text = business.businessName;
  _contactDescriptionController.text = business.contactDescription;
  _industryController.text = business.industry;
  _emailController.text = business.email;
  _phoneController.text = business.phone ?? ''; // Handle nullable phone
  _websiteController.text = business.website;
  _socialMediaLinks = List.from(business.socialMediaLinks);
  _logoUrl = business.logoUrl;
  _nichesController.text = business.niches.join(', '); // Add this line
  }

  void _handleImagePick() {
    // Implement image picking functionality here
    // For now, we'll just show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker functionality to be implemented')),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedBusiness = BusinessModel(
        id: widget.id,
        businessName: _businessNameController.text,
        logoUrl: _logoUrl ?? '',
        contactDescription: _contactDescriptionController.text,
        industry: _industryController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        website: _websiteController.text,
        socialMediaLinks: _socialMediaLinks,
        location: '',
        niches: _nichesController.text.split(',').map((e) => e.trim()).toList(), // Add this line
      );

      try {
        await _profileService.saveBusinessProfile(updatedBusiness);
        setState(() {
          _isEditing = false;
          _businessFuture = Future.value(updatedBusiness);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }
}
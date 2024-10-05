import 'package:flutter/material.dart';
import '../../services/profile_service.dart';
import '../../models/influencer_model.dart';
import '../../models/business_model.dart';
import '../../widgets/profile_image_picker.dart';

class ProfileCompletionPage extends StatefulWidget {
  final String userType;

  const ProfileCompletionPage({Key? key, required this.userType}) : super(key: key);

  @override
  _ProfileCompletionPageState createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  bool _isLoading = false;
  String? _imageUrl;

  // Common fields
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();

  // Influencer-specific fields
  final List<String> _socialMediaLinks = [];
  final List<String> _portfolio = [];

  // Business-specific fields
  final _businessNameController = TextEditingController();
  final _industryController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileImagePicker(
                imageUrl: _imageUrl,
                onTap: _handleImagePick,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter your bio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                validator: (value) => value!.isEmpty ? 'Enter your website' : null,
              ),
              const SizedBox(height: 16),
              if (widget.userType == 'Influencer') ...[
                _buildSocialMediaLinksList(),
                _buildPortfolioList(),
              ] else if (widget.userType == 'Business') ...[
                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(labelText: 'Business Name'),
                  validator: (value) => value!.isEmpty ? 'Enter your business name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _industryController,
                  decoration: const InputDecoration(labelText: 'Industry'),
                  validator: (value) => value!.isEmpty ? 'Enter your industry' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) => value!.isEmpty ? 'Enter your phone number' : null,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Complete Profile'),
                onPressed: _isLoading ? null : _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaLinksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Social Media Links', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _socialMediaLinks.length + 1,
          itemBuilder: (context, index) {
            if (index == _socialMediaLinks.length) {
              return TextButton(
                child: const Text('Add Social Media Link'),
                onPressed: _addSocialMediaLink,
              );
            }
            return ListTile(
              title: Text(_socialMediaLinks[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeSocialMediaLink(index),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPortfolioList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Portfolio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _portfolio.length + 1,
          itemBuilder: (context, index) {
            if (index == _portfolio.length) {
              return TextButton(
                child: const Text('Add Portfolio Item'),
                onPressed: _addPortfolioItem,
              );
            }
            return ListTile(
              title: Text(_portfolio[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removePortfolioItem(index),
              ),
            );
          },
        ),
      ],
    );
  }

  void _addSocialMediaLink() {
    _showAddDialog('Add Social Media Link', (value) {
      setState(() => _socialMediaLinks.add(value));
    });
  }

  void _removeSocialMediaLink(int index) {
    setState(() => _socialMediaLinks.removeAt(index));
  }

  void _addPortfolioItem() {
    _showAddDialog('Add Portfolio Item', (value) {
      setState(() => _portfolio.add(value));
    });
  }

  void _removePortfolioItem(int index) {
    setState(() => _portfolio.removeAt(index));
  }

  void _showAddDialog(String title, Function(String) onAdd) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter link or description'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                onAdd(controller.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
      setState(() => _isLoading = true);
      try {
        if (widget.userType == 'Influencer') {
          final influencer = InfluencerModel(
            uid: '', // You need to get the user ID from somewhere, maybe pass it to this page
            bio: _bioController.text,
            socialMediaLinks: _socialMediaLinks,
            portfolio: _portfolio,
          );
          await _profileService.saveInfluencerProfile(influencer);
        } else if (widget.userType == 'Business') {
          final business = BusinessModel(
            uid: '', // You need to get the user ID from somewhere, maybe pass it to this page
            businessName: _businessNameController.text,
            logoUrl: _imageUrl ?? '',
            contactDescription: _bioController.text,
            industry: _industryController.text,
            email: '', // You might want to add an email field or get it from user registration
            phone: _phoneController.text,
            website: _websiteController.text,
            socialMediaLinks: [], // You might want to add this for businesses too
          );
          await _profileService.saveBusinessProfile(business);
        }
        // Navigate to home page or show success message
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
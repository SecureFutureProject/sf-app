import 'package:flutter/material.dart';
import '../../models/influencer_model.dart';
import '../../services/profile_service.dart';
import '../../widgets/profile_image_picker.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';

class InfluencerProfilePage extends StatefulWidget {
  final String id;

  const InfluencerProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  _InfluencerProfilePageState createState() => _InfluencerProfilePageState();
}

class _InfluencerProfilePageState extends State<InfluencerProfilePage> {
  final ProfileService _profileService = ProfileService();
  late Future<InfluencerModel?> _influencerFuture;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  List<String> _socialMediaLinks = [];
  List<String> _portfolio = [];
  List<String> _niches = [];
  bool _isProfilePublic = true;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _influencerFuture = _profileService.getInfluencerProfile(widget.id);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<InfluencerModel?>(
        future: _influencerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final influencer = snapshot.data;
          if (influencer != null) {
            _populateFields(influencer);
          }

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: 24),
                      _buildNichesSection(),
                      const SizedBox(height: 24),
                      _buildSocialMediaSection(),
                      const SizedBox(height: 24),
                      _buildPortfolioSection(),
                      const SizedBox(height: 24),
                      _buildPrivacySection(),
                      if (influencer != null && !influencer.isVerified)
                        _buildVerificationButton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _isEditing = !_isEditing);
          if (!_isEditing) {
            _saveProfile();
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
      ),
    );
  }

// Profile Picture
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(_nameController.text),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade700, Colors.blue.shade500],
            ),
          ),
          child: Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: ClipOval(
                child: ProfileImagePicker(
                  imageUrl: _profileImageUrl,
                  onTap: _handleImagePick,                          // Image pick
                  enabled: _isEditing,                              // Editing
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


// Personal Information
  Widget _buildInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoItem(Icons.person, 'Name', _nameController.text),
            _buildInfoItem(Icons.email, 'Email', _emailController.text),
            _buildInfoItem(Icons.location_on, 'Location', _locationController.text),
            _buildInfoItem(Icons.phone, 'Phone', _phoneController.text),
            _buildInfoItem(Icons.description, 'Bio', _bioController.text),
          ],
        ),
      ),
    );
  }


// Icon Labels in Personal Info
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }


// Niches:
  Widget _buildNichesSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Niches',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _niches.isEmpty
                  ? [Chip(label: Text('Add your niches'))]
                  : _niches.map((niche) => Chip(
                        label: Text(niche),
                        deleteIcon: _isEditing ? const Icon(Icons.close) : null,
                        onDeleted: _isEditing ? () => setState(() => _niches.remove(niche)) : null,
                      )).toList(),
            ),
            if (_isEditing)
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Niche'),
                onPressed: () => _showAddDialog('Add Niche', (value) => setState(() => _niches.add(value))),
              ),
          ],
        ),
      ),
    );
  }

// Social Media
  Widget _buildSocialMediaSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social Media Links',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ..._buildSocialMediaLinks(),
            if (_isEditing)
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Social Media Link'),
                onPressed: _addSocialMediaLink,
              ),
          ],
        ),
      ),
    );
  }

// Portfolio:
  Widget _buildPortfolioSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ..._buildPortfolio(),
            if (_isEditing)
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Portfolio Item'),
                onPressed: _addPortfolioItem,
              ),
          ],
        ),
      ),
    );
  }

// Privacy: 
  Widget _buildPrivacySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SwitchListTile(
          title: const Text('Public Profile'),
          subtitle: const Text('Make your profile visible to others'),
          value: _isProfilePublic,
          onChanged: _isEditing ? (value) => setState(() => _isProfilePublic = value) : null,
        ),
      ),
    );
  }

// Verification 
  Widget _buildVerificationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        child: const Text('Request Verification'),
        onPressed: _requestVerification,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
    );
  }


// Profile Picture
  void _handleImagePick() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker functionality to be implemented')),
    );
  }


// Social Media
  List<Widget> _buildSocialMediaLinks() {
    return _socialMediaLinks.asMap().entries.map((entry) {
      int idx = entry.key;
      String link = entry.value;
      return ListTile(
        leading: const Icon(Icons.link, color: Colors.blue),
        title: Text(link),
        trailing: _isEditing
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => _socialMediaLinks.removeAt(idx)),
              )
            : null,
      );
    }).toList();
  }

// Portfolio
  List<Widget> _buildPortfolio() {
    return _portfolio.asMap().entries.map((entry) {
      int idx = entry.key;
      String item = entry.value;
      return ListTile(
        leading: const Icon(Icons.work, color: Colors.blue),
        title: Text(item),
        trailing: _isEditing
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => _portfolio.removeAt(idx)),
              )
            : null,
      );
    }).toList();
  }

// Socail Media
  void _addSocialMediaLink() {
    _showAddDialog('Add Social Media Link', (value) {
      setState(() => _socialMediaLinks.add(value));
    });
  }

// Portfolio
  void _addPortfolioItem() {
    _showAddDialog('Add Portfolio Item', (value) {
      setState(() => _portfolio.add(value));
    });
  }

// Add Dialog 
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

// Request Verfication:
  void _requestVerification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification request functionality to be implemented')),
    );
  }


// 
  void _populateFields(InfluencerModel influencer) {
    _bioController.text = influencer.bio;
    _nameController.text = influencer.name;
    _emailController.text = influencer.email;
    _locationController.text = influencer.location;
    _phoneController.text = influencer.phone ?? '';
    _socialMediaLinks = List.from(influencer.socialMediaLinks);
    _portfolio = List.from(influencer.portfolio);
    _niches = List.from(influencer.niches);
    _isProfilePublic = influencer.isProfilePublic;
    _profileImageUrl = influencer.id; // Assuming id is used as image name
  }

// Saving after edit 
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final currentInfluencer = await _influencerFuture;
      final updatedInfluencer = InfluencerModel(
        id: widget.id,
        name: _nameController.text,
        email: _emailController.text,
        location: _locationController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        niches: _niches,
        bio: _bioController.text,
        socialMediaLinks: _socialMediaLinks,
        portfolio: _portfolio,
        isProfilePublic: _isProfilePublic,
        isVerified: currentInfluencer?.isVerified ?? false,
      );

      try {
        await _profileService.saveInfluencerProfile(updatedInfluencer);
        setState(() {
          _isEditing = false;
          _influencerFuture = Future.value(updatedInfluencer);
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
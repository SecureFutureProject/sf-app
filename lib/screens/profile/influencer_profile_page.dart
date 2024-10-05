import 'package:flutter/material.dart';
import '../../models/influencer_model.dart';
import '../../services/profile_service.dart';
import '../../widgets/profile_image_picker.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';

class InfluencerProfilePage extends StatefulWidget {
  final String uid;

  const InfluencerProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _InfluencerProfilePageState createState() => _InfluencerProfilePageState();
}

class _InfluencerProfilePageState extends State<InfluencerProfilePage> {
  final ProfileService _profileService = ProfileService();
  late Future<InfluencerModel?> _influencerFuture;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  List<String> _socialMediaLinks = [];
  List<String> _portfolio = [];
  bool _isProfilePublic = true;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _influencerFuture = _profileService.getInfluencerProfile(widget.uid);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Influencer Profile'),
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
      body: FutureBuilder<InfluencerModel?>(
        future: _influencerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('Influencer profile not found'));
          }

          final influencer = snapshot.data!;
          _populateFields(influencer);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ProfileImagePicker(
                      imageUrl: _profileImageUrl,
                      onTap: _handleImagePick,
                      enabled: _isEditing,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Bio'),
                    maxLines: 3,
                    enabled: _isEditing,
                    validator: (value) => value!.isEmpty ? 'Bio is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Text('Social Media Links', style: Theme.of(context).textTheme.titleMedium),
                  ..._buildSocialMediaLinks(),
                  const SizedBox(height: 16),
                  Text('Portfolio', style: Theme.of(context).textTheme.titleMedium),
                  ..._buildPortfolio(),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Public Profile'),
                    value: _isProfilePublic,
                    onChanged: _isEditing ? (value) => setState(() => _isProfilePublic = value) : null,
                  ),
                  if (!influencer.isVerified)
                    ElevatedButton(
                      child: const Text('Request Verification'),
                      onPressed: _requestVerification,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleImagePick() {
    // Implement image picking functionality here
    // For now, we'll just show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker functionality to be implemented')),
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

  List<Widget> _buildPortfolio() {
    return [
      ..._portfolio.asMap().entries.map((entry) {
        int idx = entry.key;
        String item = entry.value;
        return ListTile(
          title: Text(item),
          trailing: _isEditing ? IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _portfolio.removeAt(idx)),
          ) : null,
        );
      }),
      if (_isEditing)
        ListTile(
          title: const Text('Add Portfolio Item'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPortfolioItem,
          ),
        ),
    ];
  }

  void _addSocialMediaLink() {
    _showAddDialog('Add Social Media Link', (value) {
      setState(() => _socialMediaLinks.add(value));
    });
  }

  void _addPortfolioItem() {
    _showAddDialog('Add Portfolio Item', (value) {
      setState(() => _portfolio.add(value));
    });
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

  void _populateFields(InfluencerModel influencer) {
    _bioController.text = influencer.bio;
    _socialMediaLinks = List.from(influencer.socialMediaLinks);
    _portfolio = List.from(influencer.portfolio);
    _isProfilePublic = influencer.isProfilePublic;
    _profileImageUrl = influencer.uid; // Assuming uid is used as image name
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedInfluencer = InfluencerModel(
        uid: widget.uid,
        bio: _bioController.text,
        socialMediaLinks: _socialMediaLinks,
        portfolio: _portfolio,
        isProfilePublic: _isProfilePublic,
        isVerified: (await _influencerFuture)?.isVerified ?? false,
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

  void _requestVerification() {
    // Implement verification request logic here
    // For now, we'll just show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification request functionality to be implemented')),
    );
  }
}
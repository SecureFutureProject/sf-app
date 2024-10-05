import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  String? userType;
  List<String> selectedNiches = [];

  List<String> niches = [
    'Fashion', 'Beauty', 'Fitness', 'Technology', 'Food',
    'Travel', 'Lifestyle', 'Gaming', 'Music', 'Art'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (userType == null)
              _buildUserTypeSelection()
            else
              _buildRegistrationForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Are you a Brand or an Influencer?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          child: const Text('I am a Brand', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          onPressed: () => setState(() => userType = 'Brand'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text('I am an Influencer', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          onPressed: () => setState(() => userType = 'Influencer'),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: userType == 'Brand' ? 'Brand Name' : 'Full Name'),
            validator: (value) => value!.isEmpty ? 'This field is required' : null,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Enter an email' : null,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.length < 6 ? 'Enter a password 6+ chars long' : null,
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
            validator: (value) => value!.isEmpty ? 'Enter your location' : null,
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone (optional)'),
            keyboardType: TextInputType.phone,
          ),
          if (userType == 'Influencer') ...[
            const SizedBox(height: 20),
            const Text('Select your niches:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: niches.map((String niche) {
                return FilterChip(
                  avatar: Icon(getIconForNiche(niche)),
                  label: Text(niche),
                  selected: selectedNiches.contains(niche),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedNiches.add(niche);
                      } else {
                        selectedNiches.remove(niche);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Register'),
            onPressed: () async {
              if (_formKey.currentState!.validate() && (userType == 'Brand' || selectedNiches.isNotEmpty)) {
                UserModel user = UserModel(
                  name: _nameController.text,
                  email: _emailController.text,
                  location: _locationController.text,
                  phone: _phoneController.text,
                  niches: userType == 'Influencer' ? selectedNiches : [],
                  userType: userType!,
                );
                dynamic result = await _auth.signUp(_emailController.text, _passwordController.text, user);
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not register')),
                  );
                } else {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              } else if (userType == 'Influencer' && selectedNiches.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select at least one niche')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  IconData getIconForNiche(String niche) {
    switch (niche) {
      case 'Fashion':
        return Icons.style;
      case 'Beauty':
        return Icons.face;
      case 'Fitness':
        return Icons.fitness_center;
      case 'Technology':
        return Icons.computer;
      case 'Food':
        return Icons.restaurant;
      case 'Travel':
        return Icons.flight;
      case 'Lifestyle':
        return Icons.home;
      case 'Gaming':
        return Icons.games;
      case 'Music':
        return Icons.music_note;
      case 'Art':
        return Icons.palette;
      default:
        return Icons.category;
    }
  }
}
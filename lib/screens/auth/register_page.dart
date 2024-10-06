import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final ScrollController _scrollController = ScrollController();

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

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToRegistrationForm() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black87, Colors.grey.shade900],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: 32),
                _buildUserTypeSelection(),
                SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: userType == null
                      ? SizedBox.shrink()
                      : _buildRegistrationForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Join the Revolution',
              textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              speed: Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        SizedBox(height: 8),
        Text(
          'Create your account and start your journey',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'I am a...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildUserTypeButton('Brand', Icons.business)),
            SizedBox(width: 16),
            Expanded(child: _buildUserTypeButton('Influencer', Icons.person)),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTypeButton(String type, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(type, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade800,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      onPressed: () {
        setState(() => userType = type);
        _animationController.forward();
        _scrollToRegistrationForm();
      },
    );
  }

  Widget _buildRegistrationForm() {
    return FadeTransition(
      opacity: _animation,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              label: userType == 'Brand' ? 'Brand Name' : 'Full Name',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              icon: Icons.location_on,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone (Optional)',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                }
                return null;
              },
            ),
            if (userType == 'Influencer') ...[
              SizedBox(height: 24),
              Text(
                'Select your niches:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              _buildNicheSelection(),
            ],
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Create Account', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade600,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
              onPressed: _registerUser,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade800,
        labelStyle: TextStyle(color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator ?? (value) => value!.isEmpty ? 'This field is required' : null,
    );
  }

  Widget _buildNicheSelection() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: niches.map((String niche) {
        return FilterChip(
          avatar: Icon(_getIconForNiche(niche), color: Colors.white),
          label: Text(niche, style: TextStyle(color: Colors.white)),
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
          selectedColor: Colors.blue.shade600.withOpacity(0.7),
          checkmarkColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
        );
      }).toList(),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate() && (userType == 'Brand' || selectedNiches.isNotEmpty)) {
      UserModel user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        location: _locationController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        niches: userType == 'Influencer' ? selectedNiches : [],
        userType: userType!,
      );
      dynamic result = await _auth.signUp(_emailController.text, _passwordController.text, user);
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else if (userType == 'Influencer' && selectedNiches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one niche'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  IconData _getIconForNiche(String niche) {
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
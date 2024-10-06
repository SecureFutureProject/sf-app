import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildLeftSide(),
            ),
            Expanded(
              flex: 2,
              child: _buildRightSide(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide() {
    return Container(
      color: Colors.black87.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'LOGIN TO YOUR ACCOUNT',
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSide() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      color: Colors.grey.shade900.withOpacity(0.9),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnimatedTitle(),
            SizedBox(height: 30),
            _buildAnimatedTextField(
              hintText: 'Email address',
              onChanged: (val) => setState(() => _email = val),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            ),
            SizedBox(height: 15),
            _buildAnimatedTextField(
              hintText: 'Password',
              obscureText: true,
              onChanged: (val) => setState(() => _password = val),
              validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
            ),
            SizedBox(height: 20),
            _buildLoginButton(),
            SizedBox(height: 12),
            Text(
              _error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildOrDivider(),
            SizedBox(height: 20),
            _buildCreateProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return Column(
      children: [
        Text(
          'SECURE',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'FUTURE',
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade600,
              ),
              speed: Duration(milliseconds: 200),
            ),
          ],
          isRepeatingAnimation: true,
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField({
    required String hintText,
    bool obscureText = false,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade800,
              ),
              obscureText: obscureText,
              onChanged: onChanged,
              validator: validator,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      child: Text('Log in'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          dynamic result = await _auth.signIn(_email, _password);
          if (result == null) {
            setState(() => _error = 'Could not sign in with those credentials');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      },
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white70)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('OR', style: TextStyle(color: Colors.white70)),
        ),
        Expanded(child: Divider(color: Colors.white70)),
      ],
    );
  }

  Widget _buildCreateProfileButton() {
    return OutlinedButton(
      child: Text('CREATE A PROFILE', style: TextStyle(color: Colors.white)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
    );
  }
}
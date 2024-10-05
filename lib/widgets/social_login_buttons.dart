import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SocialLoginButtons extends StatelessWidget {
  final Function() onGoogleLogin;
  final Function()? onFacebookLogin;
  final Function()? onAppleLogin;

  const SocialLoginButtons({
    Key? key,
    required this.onGoogleLogin,
    this.onFacebookLogin,
    this.onAppleLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Image.asset('assets/google_logo.png', height: 24),
          label: const Text('Continue with Google'),
          onPressed: onGoogleLogin,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (onFacebookLogin != null)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.defaultPadding),
            child: ElevatedButton.icon(
              icon: Image.asset('assets/facebook_logo.png', height: 24),
              label: const Text('Continue with Facebook'),
              onPressed: onFacebookLogin,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1877F2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        if (onAppleLogin != null)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.defaultPadding),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.apple, size: 24),
              label: const Text('Continue with Apple'),
              onPressed: onAppleLogin,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
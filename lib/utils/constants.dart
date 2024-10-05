import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color accentColor = Color(0xFFFFA726);
  static const Color errorColor = Color(0xFFD32F2F);

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  // Paddings
  static const double defaultPadding = 16.0;

  // API Endpoints
  static const String baseUrl = 'https://api.example.com';

  // Shared Preferences Keys
  static const String userIdKey = 'user_id';
  static const String userTypeKey = 'user_type';

  // App Info
  static const String appName = 'Influencer-Sponsor Matcher';
  static const String appVersion = '1.0.0';

  // List of industries for business profiles
  static const List<String> industries = [
    'Technology',
    'Fashion',
    'Food & Beverage',
    'Travel',
    'Health & Fitness',
    'Beauty',
    'Entertainment',
    'Education',
    'Finance',
    'Others',
  ];

  // List of niches for influencer profiles
  static const List<String> niches = [
    'Lifestyle',
    'Fashion',
    'Beauty',
    'Travel',
    'Food',
    'Fitness',
    'Technology',
    'Gaming',
    'Parenting',
    'Business',
  ];
}
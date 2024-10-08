import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/home_page.dart';
import 'screens/profile/influencer_profile_page.dart';
import 'screens/profile/business_profile_page.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Influencer-Sponsor Matcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<UserModel?>(
        stream: _auth.userModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final UserModel? userModel = snapshot.data;
            if (userModel == null) {
              return LoginPage();
            }
            switch (userModel.userType) {
              case 'Influencer':
                return InfluencerProfilePage(id: userModel.id);
              case 'Business':
                return BusinessProfilePage(id: userModel.id);
              default:
                return HomePage();
            }
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/influencer_profile': (context) => InfluencerProfilePage(id: _auth.currentUser?.uid ?? ''),
        '/business_profile': (context) => BusinessProfilePage(id: _auth.currentUser?.uid ?? ''),
      },
    );
  }
}
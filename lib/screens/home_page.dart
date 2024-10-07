import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: _auth.userModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserModel? user = snapshot.data;
            return Center(
              child: user != null
                  ? Text('Welcome, ${user.name}!')
                  : Text('No user signed in.'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
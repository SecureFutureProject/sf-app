import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: _auth.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return const Center(child: Text('You are not logged in!'));
            }
            return FutureBuilder<UserModel?>(
              future: _databaseService.getUser(user.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.data != null) {
                    UserModel userData = userSnapshot.data!;
                    return _buildUserProfile(context, userData);
                  } else {
                    return const Center(child: Text('Error loading user data'));
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserModel userData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      userData.name[0].toUpperCase(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    userData.email,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.person, 'User Type', userData.userType),
                  _buildDetailRow(Icons.location_on, 'Location', userData.location),
                  if (userData.phone != null)
                    _buildDetailRow(Icons.phone, 'Phone', userData.phone!),
                ],
              ),
            ),
          ),
          if (userData.userType == 'Influencer' && userData.niches.isNotEmpty)
            const SizedBox(height: 16),
          if (userData.userType == 'Influencer' && userData.niches.isNotEmpty)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
                      children: userData.niches.map((niche) => Chip(
                        label: Text(niche),
                        backgroundColor: Colors.blue.shade100,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
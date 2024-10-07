import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/influencer_model.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseService() {
    _database.databaseURL = 'https://sf-app-30c3c-default-rtdb.asia-southeast1.firebasedatabase.app/';
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _database.ref().child('users').child(user.id).set(user.toMap());
    } catch (e) {
      print('Error saving user data: ${e.toString()}');
      throw e;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DataSnapshot snapshot = await _database.ref().child('users').child(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = _convertToStringDynamicMap(snapshot.value);
        if (userData['userType'] == 'Influencer') {
          return InfluencerModel.fromMap(userData);
        }
        return UserModel.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error getting user data: ${e.toString()}');
      return null;
    }
  }

  Map<String, dynamic> _convertToStringDynamicMap(dynamic value) {
    if (value is Map) {
      return value.map((key, value) {
        if (value is List) {
          return MapEntry(key.toString(), value.map((e) => e.toString()).toList());
        } else {
          return MapEntry(key.toString(), value);
        }
      });
    }
    throw ArgumentError('Value must be a Map');
  }

  // Add methods for saving and retrieving specific user types if needed
  Future<void> saveInfluencer(InfluencerModel influencer) async {
    try {
      await _database.ref().child('users').child(influencer.id).set(influencer.toMap());
    } catch (e) {
      print('Error saving influencer data: ${e.toString()}');
      throw e;
    }
  }

  Future<InfluencerModel?> getInfluencer(String uid) async {
    try {
      DataSnapshot snapshot = await _database.ref().child('users').child(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = _convertToStringDynamicMap(snapshot.value);
        if (userData['userType'] == 'Influencer') {
          return InfluencerModel.fromMap(userData);
        }
      }
      return null;
    } catch (e) {
      print('Error getting influencer data: ${e.toString()}');
      return null;
    }
  }

  // ... You can add similar methods for BusinessModel if needed
}
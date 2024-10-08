import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/influencer_model.dart';
import '../models/business_model.dart'; // Add this import if you have a BusinessModel

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
        String userType = userData['userType'] ?? '';
        switch (userType) {
          case 'Influencer':
            return InfluencerModel.fromMap(userData);
          case 'Business':
            return BusinessModel.fromMap(userData); // Assuming you have a BusinessModel
          default:
            return UserModel.fromMap(userData);
        }
      } else {
        print('User document does not exist for uid: $uid'); // Debug print
        return null;
      }
    } catch (e) {
      print('Error getting user: ${e.toString()}');
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

  // Add a method for saving and retrieving BusinessModel
  Future<void> saveBusiness(BusinessModel business) async {
    try {
      await _database.ref().child('users').child(business.id).set(business.toMap());
    } catch (e) {
      print('Error saving business data: ${e.toString()}');
      throw e;
    }
  }

  Future<BusinessModel?> getBusiness(String uid) async {
    try {
      DataSnapshot snapshot = await _database.ref().child('users').child(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = _convertToStringDynamicMap(snapshot.value);
        if (userData['userType'] == 'Business') {
          return BusinessModel.fromMap(userData);
        }
      }
      return null;
    } catch (e) {
      print('Error getting business data: ${e.toString()}');
      return null;
    }
  }
}
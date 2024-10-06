import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String location;
  final String? phone;
  final List<String> niches;
  final String userType;      // "Influncer" or "Business"

  UserModel({
    required this.id
    required this.name,
    required this.email,
    required this.location,
    this.phone,
    required this.niches,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'location': location,
      'phone': phone,
      'niches': niches,
      'userType': userType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      phone: map['phone']?.toString(),
      niches: (map['niches'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      userType: map['userType']?.toString() ?? '',
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, location: $location, phone: $phone, niches: $niches, userType: $userType)';
  }
}
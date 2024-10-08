import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String location;
  final String? phone;
  final List<String> niches;
  final String userType;      // "Influencer" or "Business"

  const UserModel({
    required this.id,
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
      niches: List<String>.from(map['niches'] ?? []),
      userType: map['userType']?.toString() ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? location,
    String? phone,
    List<String>? niches,
    String? userType,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      niches: niches ?? this.niches,
      userType: userType ?? this.userType,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, location: $location, phone: $phone, niches: $niches, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.location == location &&
      other.phone == phone &&
      listEquals(other.niches, niches) &&
      other.userType == userType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      location.hashCode ^
      phone.hashCode ^
      niches.hashCode ^
      userType.hashCode;
  }
}
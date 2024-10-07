import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class InfluencerModel extends UserModel {
  final String bio;
  final List<String> socialMediaLinks;
  final List<String> portfolio;
  final bool isVerified;
  final bool isProfilePublic;

  InfluencerModel({
    required String id,
    required String name,
    required String email,
    required String location,
    String? phone,
    required List<String> niches,
    required this.bio,
    required this.socialMediaLinks,
    required this.portfolio,
    this.isVerified = false,
    this.isProfilePublic = true,
  }) : super(
          id: id,
          name: name,
          email: email,
          location: location,
          phone: phone,
          niches: niches,
          userType: 'Influencer',
        );

  @override
  InfluencerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? location,
    String? phone,
    List<String>? niches,
    String? userType,
    String? bio,
    List<String>? socialMediaLinks,
    List<String>? portfolio,
    bool? isVerified,
    bool? isProfilePublic,
  }) {
    return InfluencerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      niches: niches ?? this.niches,
      bio: bio ?? this.bio,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      portfolio: portfolio ?? this.portfolio,
      isVerified: isVerified ?? this.isVerified,
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'bio': bio,
      'socialMediaLinks': socialMediaLinks,
      'portfolio': portfolio,
      'isVerified': isVerified,
      'isProfilePublic': isProfilePublic,
    };
  }

  factory InfluencerModel.fromMap(Map<String, dynamic> map) {
    return InfluencerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'],
      niches: List<String>.from(map['niches'] ?? []),
      bio: map['bio'] ?? '',
      socialMediaLinks: List<String>.from(map['socialMediaLinks'] ?? []),
      portfolio: List<String>.from(map['portfolio'] ?? []),
      isVerified: map['isVerified'] ?? false,
      isProfilePublic: map['isProfilePublic'] ?? true,
    );
  }

  factory InfluencerModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InfluencerModel.fromMap({...data, 'id': doc.id});
  }
}
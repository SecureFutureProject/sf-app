import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class InfluencerModel {
  final String id;
  final String bio;
  final List<String> socialMediaLinks;
  final List<String> portfolio;
  final bool isVerified;
  final bool isProfilePublic;

  InfluencerModel({
    required this.id,
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
  }): super(
          id: id,
          name: name,
          email: email,
          location: location,
          phone: phone,
          niches: niches,
          userType: 'Influencer',
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'socialMediaLinks': socialMediaLinks,
      'portfolio': portfolio,
      'isVerified': isVerified,
      'isProfilePublic': isProfilePublic,
    };
  }

  Map<String, dynamic> toFullMap() {
    return {
      ...super.toMap(),
      ...toMap(),
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
    return InfluencerModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
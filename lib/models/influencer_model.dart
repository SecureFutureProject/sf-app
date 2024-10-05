import 'package:cloud_firestore/cloud_firestore.dart';

class InfluencerModel {
  final String uid;
  final String bio;
  final List<String> socialMediaLinks;
  final List<String> portfolio;
  final bool isVerified;
  final bool isProfilePublic;

  InfluencerModel({
    required this.uid,
    required this.bio,
    required this.socialMediaLinks,
    required this.portfolio,
    this.isVerified = false,
    this.isProfilePublic = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'bio': bio,
      'socialMediaLinks': socialMediaLinks,
      'portfolio': portfolio,
      'isVerified': isVerified,
      'isProfilePublic': isProfilePublic,
    };
  }

  factory InfluencerModel.fromMap(Map<String, dynamic> map) {
    return InfluencerModel(
      uid: map['uid'] ?? '',
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
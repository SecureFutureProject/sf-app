import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class BusinessModel extends UserModel {
  final String businessName;
  final String logoUrl;
  final String contactDescription;
  final String industry;
  final String website;
  final List<String> socialMediaLinks;

  BusinessModel({
    required String id,
    required this.businessName,
    required String email,
    required String location,
    String? phone,
    required List<String> niches,
    required this.logoUrl,
    required this.contactDescription,
    required this.industry,
    required this.website,
    required this.socialMediaLinks,
  }) : super(
          id: id,
          name: businessName,
          email: email,
          location: location,
          phone: phone,
          niches: niches,
          userType: 'Business',
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'logoUrl': logoUrl,
      'contactDescription': contactDescription,
      'industry': industry,
      'website': website,
      'socialMediaLinks': socialMediaLinks,
    };
  }

  Map<String, dynamic> toFullMap() {
    return {
      ...super.toMap(),
      ...toMap(),
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'] ?? '',
      businessName: map['businessName'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'],
      niches: List<String>.from(map['niches'] ?? []),
      logoUrl: map['logoUrl'] ?? '',
      contactDescription: map['contactDescription'] ?? '',
      industry: map['industry'] ?? '',
      website: map['website'] ?? '',
      socialMediaLinks: List<String>.from(map['socialMediaLinks'] ?? []),
    );
  }

  factory BusinessModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusinessModel.fromMap({...data, 'id': doc.id});
  }
}
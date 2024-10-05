import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessModel {
  final String uid;
  final String businessName;
  final String logoUrl;
  final String contactDescription;
  final String industry;
  final String email;
  final String phone;
  final String website;
  final List<String> socialMediaLinks;

  BusinessModel({
    required this.uid,
    required this.businessName,
    required this.logoUrl,
    required this.contactDescription,
    required this.industry,
    required this.email,
    required this.phone,
    required this.website,
    required this.socialMediaLinks,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'businessName': businessName,
      'logoUrl': logoUrl,
      'contactDescription': contactDescription,
      'industry': industry,
      'email': email,
      'phone': phone,
      'website': website,
      'socialMediaLinks': socialMediaLinks,
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      uid: map['uid'] ?? '',
      businessName: map['businessName'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      contactDescription: map['contactDescription'] ?? '',
      industry: map['industry'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      website: map['website'] ?? '',
      socialMediaLinks: List<String>.from(map['socialMediaLinks'] ?? []),
    );
  }

  factory BusinessModel.fromDocument(DocumentSnapshot doc) {
    return BusinessModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
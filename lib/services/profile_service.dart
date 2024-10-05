import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/influencer_model.dart';
import '../models/business_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveInfluencerProfile(InfluencerModel influencer) async {
    try {
      await _firestore.collection('influencers').doc(influencer.uid).set(influencer.toMap());
    } catch (e) {
      print('Error saving influencer profile: ${e.toString()}');
      throw e;
    }
  }

  Future<void> saveBusinessProfile(BusinessModel business) async {
    try {
      await _firestore.collection('businesses').doc(business.uid).set(business.toMap());
    } catch (e) {
      print('Error saving business profile: ${e.toString()}');
      throw e;
    }
  }

  Future<InfluencerModel?> getInfluencerProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('influencers').doc(uid).get();
      if (doc.exists) {
        return InfluencerModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting influencer profile: ${e.toString()}');
      return null;
    }
  }

  Future<BusinessModel?> getBusinessProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('businesses').doc(uid).get();
      if (doc.exists) {
        return BusinessModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting business profile: ${e.toString()}');
      return null;
    }
  }

  Future<void> updateInfluencerVerificationStatus(String uid, bool isVerified) async {
    try {
      await _firestore.collection('influencers').doc(uid).update({'isVerified': isVerified});
    } catch (e) {
      print('Error updating influencer verification status: ${e.toString()}');
      throw e;
    }
  }

  Future<void> updateInfluencerPrivacySettings(String uid, bool isPublic) async {
    try {
      await _firestore.collection('influencers').doc(uid).update({'isProfilePublic': isPublic});
    } catch (e) {
      print('Error updating influencer privacy settings: ${e.toString()}');
      throw e;
    }
  }
}
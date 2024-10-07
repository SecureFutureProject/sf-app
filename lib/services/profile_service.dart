import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/influencer_model.dart';
import '../models/business_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveInfluencerProfile(InfluencerModel influencer) async {
    try {
      await _firestore.collection('influencers').doc(influencer.id).set(influencer.toMap());
    } catch (e) {
      print('Error saving influencer profile: ${e.toString()}');
      throw e;
    }
  }

  Future<void> saveBusinessProfile(BusinessModel business) async {
    try {
      await _firestore.collection('businesses').doc(business.id).set(business.toMap());
    } catch (e) {
      print('Error saving business profile: ${e.toString()}');
      throw e;
    }
  }

  Future<InfluencerModel?> getInfluencerProfile(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('influencers').doc(id).get();
      if (doc.exists) {
        return InfluencerModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting influencer profile: ${e.toString()}');
      return null;
    }
  }

  Future<BusinessModel?> getBusinessProfile(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('businesses').doc(id).get();
      if (doc.exists) {
        return BusinessModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting business profile: ${e.toString()}');
      return null;
    }
  }

  Future<void> updateInfluencerVerificationStatus(String id, bool isVerified) async {
    try {
      await _firestore.collection('influencers').doc(id).update({'isVerified': isVerified});
    } catch (e) {
      print('Error updating influencer verification status: ${e.toString()}');
      throw e;
    }
  }

  Future<void> updateInfluencerPrivacySettings(String id, bool isPublic) async {
    try {
      await _firestore.collection('influencers').doc(id).update({'isProfilePublic': isPublic});
    } catch (e) {
      print('Error updating influencer privacy settings: ${e.toString()}');
      throw e;
    }
  }
}
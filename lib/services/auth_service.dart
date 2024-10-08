import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn? _googleSignIn = GoogleSignIn();
  final DatabaseService _databaseService = DatabaseService();

  Stream<UserModel?> get userModel => _auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;
    return await _databaseService.getUser(user.uid);
  });

  Future<UserModel?> signIn(String email, String password) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    UserModel? user = await _databaseService.getUser(result.user!.uid);
    print('User retrieved from database: ${user?.toString()}'); // Debug print
    return user;
  } catch (e) {
    print('Error signing in: ${e.toString()}');
    return null;
  }
}

  Future<UserModel?> signUp(String email, String password, UserModel user) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user = user.copyWith(id: result.user!.uid);  // Ensure the user model has the correct UID
      await _databaseService.saveUser(user);
      return user;
    } catch (e) {
      print('Error signing up: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    if (_googleSignIn == null) {
      print('Google Sign-In is not available');
      return null;
    }
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      return await _databaseService.getUser(result.user!.uid);
    } catch (e) {
      print('Error signing in with Google: ${e.toString()}');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      throw e;
    }
  }

  Future<void> enableTwoFactor() async {
    try {
      // This is a placeholder. Actual implementation depends on your specific requirements
      print('Two-factor authentication to be implemented');
    } catch (e) {
      print('Error enabling two-factor authentication: $e');
      throw e;
    }
  }

  User? get currentUser => _auth.currentUser;
}
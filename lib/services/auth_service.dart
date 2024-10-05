import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error signing in: ${e.toString()}');
      return null;
    }
  }

  Future<User?> signUp(String email, String password, UserModel user) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _databaseService.saveUser(result.user!.uid, user);
      return result.user;
    } catch (e) {
      print('Error signing up: ${e.toString()}');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
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
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../models/user_model.dart';
// import 'database_service.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final DatabaseService _databaseService = DatabaseService();

//   Stream<User?> get user => _auth.authStateChanges();

//   Future<User?> signIn(String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return result.user;
//     } catch (e) {
//       print('Error signing in: ${e.toString()}');
//       return null;
//     }
//   }

//   Future<User?> signUp(String email, String password, UserModel user) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       await _databaseService.saveUser(result.user!.uid, user);
//       return result.user;
//     } catch (e) {
//       print('Error signing up: ${e.toString()}');
//       return null;
//     }
//   }

//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       UserCredential result = await _auth.signInWithCredential(credential);
//       return result.user;
//     } catch (e) {
//       print('Error signing in with Google: ${e.toString()}');
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       print('Error signing out: ${e.toString()}');
//     }
//   }

//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       print('Error sending password reset email: $e');
//       throw e;
//     }
//   }

//   Future<void> enableTwoFactor() async {
//     try {
//       await _auth.currentUser!.multiFactor.enroll(PhoneMultiFactorGenerator.getAssertion());
//     } catch (e) {
//       print('Error enabling two-factor authentication: $e');
//       throw e;
//     }
//   }
// }
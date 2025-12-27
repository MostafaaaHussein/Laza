import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =======================
  // SIGN UP
  // =======================
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': name,
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }

  // =======================
  // LOGIN
  // =======================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // =======================
  // LOGOUT
  // =======================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // =======================
  // PASSWORD RESET
  // =======================
  Future<void> sendPasswordResetEmail(String email, {String? otp}) async {
    try {
      // 1. Send reset email via Auth (sends the secure link)
      // Note: Professional branding ("Laza") is configured in Firebase Console -> Auth -> Templates
      await _auth.sendPasswordResetEmail(email: email);
      
      // 2. Find user's UID by email to record the request
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final uid = userQuery.docs.first.id;
        
        // 3. Record reset request in Firestore safely
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('resetPassword')
            .add({
          'email': email,
          'requestedAt': FieldValue.serverTimestamp(),
          'otp': otp ?? '0000',
          'status': 'requested',
        });
      } else {
        // Throw a specific error so the UI can tell the user they aren't registered
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'This email is not registered in our system.',
        );
      }
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }

  // =======================
  // CURRENT USER
  // =======================
  User? get currentUser => _auth.currentUser;

  Future<String?> getUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['name'] as String?;
      }
    }
    return null;
  }

  // =======================
  // ERROR HANDLING
  // =======================
  String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      default:
        return 'An undefined Error happened.';
    }
  }
}

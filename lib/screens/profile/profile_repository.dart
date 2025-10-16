import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User get currentUser {
    final u = _auth.currentUser;
    if (u == null) throw StateError('No signed-in user');
    return u;
  }

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  Future<Map<String, dynamic>> load() async {
    try {
      final u = currentUser;
      final snap = await _doc(u.uid).get();
      final data = snap.data() ?? {};

      return {
        'email': u.email,
        'emailVerified': u.emailVerified,
        'displayName': data['displayName'] ?? u.displayName ?? '',
        'car': {
          'make': data['car']?['make'] ?? '',
          'model': data['car']?['model'] ?? '',
          'color': data['car']?['color'] ?? '',
          'plate': data['car']?['plate'] ?? '',
        },
      };
    } catch (e) {
      throw 'profile_repository.load failed: $e';
    }
  }

  Future<void> save({
    required String displayName,
    required String make,
    required String model,
    required String color,
    required String plate,
  }) async {
    final u = currentUser;
    await _doc(u.uid).set({
      'displayName': displayName,
      'car': {
        'make': make,
        'model': model,
        'color': color,
        'plate': plate,
      }
    }, SetOptions(merge: true));

    if (displayName.isNotEmpty && displayName != (u.displayName ?? '')) {
      await u.updateDisplayName(displayName);
    }
  }

  Future<void> sendVerifyEmailIfNeeded() async {
    final u = currentUser;
    if (!u.emailVerified) await u.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

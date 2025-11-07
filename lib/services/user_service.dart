import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<Map<String, dynamic>?> getUserDoc() async {
    final id = uid;
    if (id == null) return null;
    final snap = await _db.collection('users').doc(id).get();
    return snap.data();
  }

  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateDisplayName(name);
    await _db.collection('users').doc(user.uid).set(
      {'displayName': name},
      SetOptions(merge: true),
    );
  }

  Future<void> updateEmail(String email) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateEmail(email);
    await _db.collection('users').doc(user.uid).set(
      {'email': email},
      SetOptions(merge: true),
    );
  }

  Future<void> updateWallet(num amount) async {
    final id = uid;
    if (id == null) return;
    await _db.collection('users').doc(id).set(
      {'wallet': amount},
      SetOptions(merge: true),
    );
  }
}

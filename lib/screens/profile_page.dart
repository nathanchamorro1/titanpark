import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:titanpark/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _svc = UserService();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  bool _saving = false;
  bool _editing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Prefer user.email; fall back to providerData if needed
  String? _authEmail(User? u) {
    if (u == null) return null;
    if ((u.email ?? '').isNotEmpty) return u.email;
    for (final p in u.providerData) {
      final e = p.email;
      if (e != null && e.isNotEmpty) return e;
    }
    return null;
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      // On web, currentUser can be null briefly; wait for the first non-null.
      final user = await FirebaseAuth.instance
          .authStateChanges()
          .firstWhere((u) => u != null);

      // Service uses server+cache with cache fallback (handles flaky network).
      final data = await _svc.getUserDoc();

      _nameCtrl.text =
          (data?['displayName'] as String?)?.trim() ?? (user!.displayName ?? '');
      _emailCtrl.text =
          (data?['email'] as String?)?.trim() ?? (_authEmail(user) ?? '');

      setState(() {});
    } on FirebaseException catch (e) {
      setState(() => _error = e.message ?? e.code);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();

      // Update display name (Auth + Firestore)
      if (name.isNotEmpty && name != (user?.displayName ?? '')) {
        await _svc.updateDisplayName(name);
      }

      // Try Auth email update (may require recent login).
      // Regardless, keep Firestore email in sync so UI shows the change.
      if (email.isNotEmpty && email != (user?.email ?? '')) {
        try {
          await _svc.updateEmail(email);
        } on FirebaseAuthException catch (e) {
          // Save email to Firestore so it displays, and notify user to re-login.
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set({'email': email}, SetOptions(merge: true));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Email not updated in Auth (${e.code}). Saved here — please sign out/in to finalize.',
                ),
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() => _editing = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile saved')));
      }
    } on FirebaseException catch (e) {
      if (mounted) setState(() => _error = e.message ?? e.code);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Back (left) + Edit toggle (left) as you requested
      appBar: AppBar(
        title: const Text('Profile'),
        leadingWidth: 120,
        leading: Row(
          children: [
            const BackButton(),
            TextButton(
              onPressed: () => setState(() => _editing = !_editing),
              child: Text(_editing ? 'Done' : 'Edit'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    enabled: _editing,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                    autofillHints: const [AutofillHints.name],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    enabled: _editing,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isEmpty) return 'Required';
                      final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(t);
                      return ok ? null : 'Invalid email';
                    },
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (_editing && !_saving) ? _save : null,
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    title: const Text('Manage Reservations'),
                    subtitle: const Text('View or cancel your reservations'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).pushNamed('/reservation'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

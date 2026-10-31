import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_repository.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;

  const ProfilePage({super.key, required this.loginName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _repo = UserRepository();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Populate fields from the repository (already loaded on LoginPage).
    _firstNameController.text = _repo.firstName;
    _lastNameController.text = _repo.lastName;
    _phoneController.text = _repo.phone;
    _emailController.text = _repo.email;

    // Show "Welcome Back <name>" Snackbar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome Back ${widget.loginName}'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Push current field values back into the repository and save.
    _repo.firstName = _firstNameController.text;
    _repo.lastName = _lastNameController.text;
    _repo.phone = _phoneController.text;
    _repo.email = _emailController.text;
    _repo.saveData();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Attempts to launch [uri]. If no app can handle it, shows an AlertDialog.
  Future<void> _launchOrAlert(Uri uri, String scheme) async {
    try {
      final ok = await launchUrl(uri);
      if (!ok) {
        _showUnsupportedDialog(scheme);
      }
    } catch (_) {
      _showUnsupportedDialog(scheme);
    }
  }

  void _showUnsupportedDialog(String scheme) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Not supported'),
        content: Text('The "$scheme:" URL is not supported on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Text(
              'Welcome Back ${widget.loginName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // First name
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Last name
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Phone number with Tel + SMS buttons
            Row(
              children: [
                // Flexible is REQUIRED — TextField is unbounded-width and
                // would crash inside a Row without it.
                Flexible(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final num = _phoneController.text.trim();
                    if (num.isEmpty) return;
                    _launchOrAlert(Uri(scheme: 'tel', path: num), 'tel');
                  },
                  child: const Icon(Icons.call),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: () {
                    final num = _phoneController.text.trim();
                    if (num.isEmpty) return;
                    _launchOrAlert(Uri(scheme: 'sms', path: num), 'sms');
                  },
                  child: const Icon(Icons.message),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Email + mail button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    if (email.isEmpty) return;
                    _launchOrAlert(
                      Uri(scheme: 'mailto', path: email),
                      'mailto',
                    );
                  },
                  child: const Icon(Icons.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controllers to read/clear the fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Secure storage (uses EncryptedSharedPreferences on Android)
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Image source starts as the question mark.
  // Change these paths to match your actual asset file names.
  String imageSource = 'assets/images/question-mark.png';

  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Load username/password from secure storage on startup.
  /// If found, populate the fields and show a Snackbar with an "Undo" action.
  Future<void> _loadSavedCredentials() async {
    final savedName = await _storage.read(key: _keyUsername);
    final savedPassword = await _storage.read(key: _keyPassword);

    if (savedName == null || savedPassword == null) return;

    // Populate the text fields
    setState(() {
      _nameController.text = savedName;
      _passwordController.text = savedPassword;
    });

    // Show Snackbar after the first frame so ScaffoldMessenger is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Previous login name and password loaded'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Clear the text fields ONLY.
              // Do NOT delete from secure storage, so a restart reloads them.
              setState(() {
                _nameController.text = '';
                _passwordController.text = '';
              });
            },
          ),
        ),
      );
    });
  }

  /// Called when the user presses the Login button.
  Future<void> _onLoginPressed() async {
    // 1) Update the image based on the password
    setState(() {
      if (_passwordController.text == 'QWERTY123') {
        imageSource = 'assets/images/light-bulb.png';
      } else {
        imageSource = 'assets/images/stop-sign.png';
      }
    });

    // 2) Ask the user whether to save the credentials
    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Save credentials?'),
          content: const Text(
            'Would you like to save your username and password for next time?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // 3) Save or clear accordingly
    if (shouldSave == true) {
      await _storage.write(key: _keyUsername, value: _nameController.text);
      await _storage.write(key: _keyPassword, value: _passwordController.text);
    } else {
      // "No" or dialog dismissed -> clear any stored data
      await _storage.deleteAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4 Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // Login name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Login name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Password field (obscured)
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),

            // 300 x 300 image that swaps based on the password
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: Text('Missing image:\n$imageSource'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
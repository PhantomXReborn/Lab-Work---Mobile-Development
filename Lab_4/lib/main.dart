// Entry point imports: Material UI + secure storage plugin.
// flutter_secure_storage maps to EncryptedSharedPreferences on Android.
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// App bootstrap.
void main() {
  runApp(const MyApp());
}

// Root widget: sets up the MaterialApp and routes to the login page.
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

// Stateful login page because we mutate UI state (text, image, snackbar).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers let us read what the user typed and clear the fields later.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Secure storage handle.
  // NOTE: on Android, pass AndroidOptions(encryptedSharedPreferences: true)
  // to explicitly use EncryptedSharedPreferences as the lab requires.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Current image shown below the Login button.
  // Starts as the question mark; swapped in _onLoginPressed().
  String imageSource = 'assets/images/question-mark.png';

  // Storage keys — using constants avoids typos between write and read.
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';

  // Runs once when the page is first built.
  @override
  void initState() {
    super.initState();
    // Restore any previously saved credentials (Lab 4 requirement #3).
    _loadSavedCredentials();
  }

  // Always dispose controllers to avoid memory leaks.
  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Reads username/password from secure storage on startup.
  /// If BOTH are present, populate the TextFields and show a Snackbar
  /// with an "Undo" action that clears the fields (but keeps storage).
  Future<void> _loadSavedCredentials() async {
    final savedName = await _storage.read(key: _keyUsername);
    final savedPassword = await _storage.read(key: _keyPassword);

    // Nothing saved (first run, or user pressed "No" last time) -> do nothing.
    if (savedName == null || savedPassword == null) return;

    // Guard: widget may have been disposed while awaiting storage.
    if (!mounted) return;

    // Repopulate the fields so the user sees their old credentials.
    setState(() {
      _nameController.text = savedName;
      _passwordController.text = savedPassword;
    });

    // Defer Snackbar until after the current frame so ScaffoldMessenger
    // (which is created during build) is guaranteed to exist.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Previous login name and password loaded'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Lab 4 requirement #5: clear the fields ONLY.
              // Do NOT touch secure storage — on next app start the
              // credentials will be reloaded and the Snackbar will reappear.
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

  /// Handler for the Login button. Does two things:
  ///   1. Swaps the image (Lab 2 logic).
  ///   2. Asks the user whether to save credentials to secure storage
  ///      (Lab 4 logic), then saves or clears accordingly.
  Future<void> _onLoginPressed() async {
    // ---- 1) Lab 2: image feedback based on the password ----
    setState(() {
      if (_passwordController.text == 'QWERTY123') {
        imageSource = 'assets/images/light-bulb.png'; // success
      } else {
        imageSource = 'assets/images/stop-sign.png';  // failure
      }
    });

    // ---- 2) Lab 4: prompt to save credentials ----
    // showDialog returns the value passed to Navigator.pop():
    //   true  -> user pressed "Yes"
    //   false -> user pressed "No"
    //   null  -> dialog dismissed (tap outside / back button)
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
              onPressed: () => Navigator.of(ctx).pop(false), // No
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),  // Yes
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // ---- 3) Act on the user's choice ----
    if (shouldSave == true) {
      // Persist both strings. On Android this goes into
      // EncryptedSharedPreferences via the plugin.
      await _storage.write(key: _keyUsername, value: _nameController.text);
      await _storage.write(key: _keyPassword, value: _passwordController.text);
    } else {
      // "No" (or dismissed) -> clear any previously stored credentials.
      // Prefer delete(key: ...) twice over deleteAll() so you don't
      // accidentally wipe unrelated keys in the same storage.
      await _storage.deleteAll();
    }
  }

  // Builds the UI: two fields, a button, and the 300x300 image.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4 Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // Login name field — plain text.
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Login name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Password field — obscureText hides what's typed (Lab 2 req #1).
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Login button — triggers image swap + save dialog.
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),

            // 300x300 image. Its asset path lives in `imageSource` so
            // setState() can swap between question-mark / light-bulb / stop-sign.
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
              // Friendly fallback if an asset is missing from pubspec.yaml.
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
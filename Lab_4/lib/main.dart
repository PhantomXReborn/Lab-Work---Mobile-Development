import 'package:flutter/material.dart';
import 'user_repository.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5',
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _repo = UserRepository();

  String imageSource = 'assets/images/question-mark.png';

  static const String _defaultPassword = 'QWERTY123';

  @override
  void initState() {
    super.initState();
    _initRepository();
  }

  /// Load the repository once at app startup.
  /// Also repopulates the login TextFields (Lab 4 behaviour).
  Future<void> _initRepository() async {
    await _repo.loadData();

    if (!mounted) return;

    // Only show snackbar + repopulate if a username/password were saved.
    if (_repo.username.isNotEmpty && _repo.password.isNotEmpty) {
      setState(() {
        _nameController.text = _repo.username;
        _passwordController.text = _repo.password;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Previous login name and password loaded'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _nameController.text = '';
                  _passwordController.text = '';
                });
                // Do NOT clear _repo — storage stays intact.
              },
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    // Lab 5: save repository on dispose.
    _repo.saveData();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    final entered = _passwordController.text;
    final enteredName = _nameController.text;

    // ---- Validate password (Lab 2 logic) ----
    bool isValid = entered == _defaultPassword;
    if (!isValid && _repo.password.isNotEmpty && _repo.password == entered) {
      isValid = true;
    }

    if (!mounted) return;
    setState(() {
      imageSource = isValid
          ? 'assets/images/light-bulb.png'
          : 'assets/images/stop-sign.png';
    });

    // ---- Lab 4: ask to save credentials ----
    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save credentials?'),
        content: const Text(
          'Would you like to save your username and password for next time?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      _repo.username = enteredName;
      _repo.password = entered;
      await _repo.saveData();
    } else {
      await _repo.clearCredentials();
    }

    // ---- Lab 5: navigate on success ----
    if (isValid && mounted) {
      _repo.username = enteredName;
      await _repo.saveData();

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfilePage(loginName: enteredName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 5 Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Login name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
              errorBuilder: (_, __, ___) => Container(
                width: 300,
                height: 300,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: Text('Missing image:\n$imageSource'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
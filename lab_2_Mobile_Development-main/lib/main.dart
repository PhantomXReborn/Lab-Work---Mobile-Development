import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Home Page',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
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
  // Controllers to read what the user typed
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Image source starts as the question mark
  String imageSource = 'assets/images/question-mark.png';

  // The correct password
  static const String correctPassword = 'QWERTY123';

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // Read the password string
    final String password = _passwordController.text;

    setState(() {
      if (password == correctPassword) {
        imageSource = 'assets/images/light-bulb.png';
      } else {
        imageSource = 'assets/images/stop-sign.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- Login name field ----
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ---- Password field (obscured) ----
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // ---- Login button ----
              ElevatedButton(
                onPressed: _onLoginPressed,
                child: const Text('Login', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 30),

              // ---- Dynamic Image (300 x 300) ----
              Image.asset(
                imageSource,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
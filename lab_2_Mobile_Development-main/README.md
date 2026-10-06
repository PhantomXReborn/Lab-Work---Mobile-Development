FLUTTER LOGIN PAGE
==================

A simple Flutter application that demonstrates a login screen with
password validation and a dynamic image that changes based on whether
the entered password is correct or incorrect.


FEATURES
--------

- Material Design UI with a deep purple primary theme
- White scaffold background for a clean, minimal look
- Two text input fields: "Login" and "Password"
- Password field is obscured (hidden characters)
- Login button that validates the entered password
- Dynamic 300x300 image that updates based on login result:
    * question-mark.png  -> default state (before login)
    * light-bulb.png     -> shown when the password is correct
    * stop-sign.png      -> shown when the password is incorrect
- TextEditingControllers are properly disposed to prevent memory leaks


HOW IT WORKS
------------

1. The app starts at the LoginPage widget.

2. The user types a username into the "Login" field and a password
   into the "Password" field (the password is hidden as they type).

3. When the user taps the "Login" button, the _onLoginPressed()
   method runs. It compares the typed password against the hardcoded
   correct password: "QWERTY123".

4. setState() is called to update the image on screen:
     - If the password matches -> light-bulb.png (success)
     - If the password does not match -> stop-sign.png (failure)

5. The image is displayed below the button at 300x300 pixels,
   scaled to fit inside its box.


PROJECT STRUCTURE
-----------------

lib/
  main.dart          -> App entry point, theme, LoginPage widget


KEY WIDGETS / CLASSES
---------------------

MyApp
  - Root StatelessWidget
  - Sets up MaterialApp with title and theme
  - Uses deepPurple as the primary swatch
  - Sets scaffold background to white
  - Sets LoginPage as the home screen

LoginPage
  - StatefulWidget that renders the login screen

_LoginPageState
  - Holds the state for LoginPage
  - Contains:
      * _loginController (TextEditingController for username)
      * _passwordController (TextEditingController for password)
      * imageSource (String path to the current image)
      * correctPassword (constant: 'QWERTY123')
  - Overrides dispose() to clean up controllers
  - Contains _onLoginPressed() to handle the login logic
  - Builds the UI using a Scaffold + AppBar + SingleChildScrollView


UI LAYOUT (top to bottom)
-------------------------

1. AppBar with title "Flutter Demo Home Page"
2. TextField: "Login" (outlined, with label)
3. Spacer (16px)
4. TextField: "Password" (outlined, obscured)
5. Spacer (20px)
6. ElevatedButton: "Login" (font size 20)
7. Spacer (30px)
8. Image (300x300, dynamically changes)


ASSETS REQUIRED
---------------

Place these images in your project's assets/images/ folder:

  - question-mark.png   (default state)
  - light-bulb.png      (correct password)
  - stop-sign.png       (incorrect password)

Then register the folder in pubspec.yaml:

  flutter:
    assets:
      - assets/images/


GETTING STARTED
---------------

1. Clone the repository:
     - git clone https://github.com/your-username/flutter-login-page.git
     - cd flutter-login-page

2. Install dependencies:
     flutter pub get

3. Run the app:
     flutter run


THEME
-----

  Primary Swatch       : Colors.deepPurple
  Scaffold Background  : Colors.white
  App Title            : "Flutter Demo Home Page"


BUILT WITH
----------

  - Flutter (https://flutter.dev)
  - Dart    (https://dart.dev)


NOTES
-----

- The password "QWERTY123" is hardcoded for demo purposes only.
  In a real app, never store credentials in source code.
- This project is intended as a learning example for Flutter
  beginners covering: StatefulWidget, TextEditingController,
  setState(), asset images, and basic form input.


LICENSE
-------

MIT License


CONTRIBUTING
------------

Contributions, issues, and feature requests are welcome.
Feel free to fork the project and open a pull request.

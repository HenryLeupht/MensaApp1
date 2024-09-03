// views/login_view.dart
import 'package:flutter/material.dart';
import '../utils/user_session.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController(); // Textfeld für Benutzername
  final TextEditingController _passwordController = TextEditingController(); // Textfeld für Passwort
  String _errorMessage = "";

  void _login() {
    String username = _usernameController.text; // Benutzername aus Textfeld holen
    String password = _passwordController.text; // Passwort aus Textfeld holen

    if (username == 'admin123' && password == 'adminPass') { // Benutzername und Passwort prüfen
      UserSession.username = username; // Benutzername in UserSession speichern
      Navigator.pushReplacementNamed(context, '/meal_plan'); // Weiterleitung zur Essensplan-Übersicht
      print("Logged in as Admin");  // Debug-Ausgabe
    } else {
      setState(() {
        _errorMessage = "Ungültiger Benutzername oder Passwort"; // Fehlermeldung setzen
      });
    }
  }

  @override
  Widget build(BuildContext context) { // Widget für die Login-Seite
    return Scaffold( // Scaffold für die Login-Seite
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding( // Padding für den Inhalt
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Benutzername'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

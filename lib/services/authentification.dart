// lib/services/authentification.dart
class AuthService {
  // Dummy users
  final Map<String, String> _users = {
    'admin': 'admin123',
    'user': 'user123',
  };

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (_users.containsKey(username) && _users[username] == password) {
      return true;
    }
    return false;
  }
}

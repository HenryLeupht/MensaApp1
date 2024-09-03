class UserSession {
  static String? username;

  static bool isAdmin() {
    return username == 'admin123';  // Beispiel-Admin-Username
  }
}
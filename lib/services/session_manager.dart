class SessionManager {
  static int? userId;
  static String? fullName;
  static String? email;

  static void saveUser({
    required int userId,
    required String fullName,
    required String email,
  }) {
    SessionManager.userId = userId;
    SessionManager.fullName = fullName;
    SessionManager.email = email;
  }

  static void clearSession() {
    userId = null;
    fullName = null;
    email = null;
  }

  static bool get isLoggedIn => userId != null;
}

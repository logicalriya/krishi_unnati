import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// A lightweight local "database" built on SharedPreferences (JSON-encoded
/// records). This keeps the app fully offline-first and avoids pulling in
/// a native SQL plugin that can't be verified to build in this environment,
/// while still giving real persistence for accounts, sessions, profile
/// edits and scan history across app restarts.
///
/// The API surface (register/login/session/history) is intentionally
/// shaped like a small REST backend so swapping this out for a real
/// server + database later only means changing this one file.
class LocalDb {
  static const _usersKey = 'ku_users';
  static const _sessionKey = 'ku_session';
  static const _historyKey = 'ku_scan_history';

  /// Generates and stores a one-time password for `phone`, valid for 5
  /// minutes, replacing any previous unexpired OTP for that number. This
  /// is genuine random generation + persisted server-side-style
  /// verification — not a hardcoded code — but there is still no real
  /// SMS gateway wired in (see the note where this is called), so the
  /// code is shown to the person directly instead of being texted to
  /// them.
  static Future<String> generateOtp(String phone) async {
    final otp = (100000 + Random().nextInt(900000)).toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'ku_otp_$phone',
      jsonEncode({
        'code': otp,
        'expiresAt': DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
      }),
    );
    return otp;
  }

  /// Verifies an entered OTP against the stored one for `phone`. Returns
  /// null on success, or an error message otherwise. Consumes the OTP on
  /// success so it can't be reused.
  static Future<String?> verifyOtp(String phone, String entered) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('ku_otp_$phone');
    if (raw == null) return 'Request a verification code first.';

    final data = jsonDecode(raw) as Map<String, dynamic>;
    final expiresAt = DateTime.tryParse(data['expiresAt'] as String? ?? '');
    if (expiresAt == null || DateTime.now().isAfter(expiresAt)) {
      await prefs.remove('ku_otp_$phone');
      return 'Verification code expired. Please request a new one.';
    }
    if (data['code'] != entered.trim()) {
      return 'Incorrect verification code.';
    }

    await prefs.remove('ku_otp_$phone');
    return null;
  }

  // ------------------------------------------------------------
  // USERS / AUTH
  // ------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  static Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// Registers a new user. Returns an error message, or null on success.
  static Future<String?> register({
    required String fullName,
    required String phone,
    required String password,
    required String role, // 'farmer' or 'admin'
    String? village,
    String? district,
  }) async {
    final users = await _loadUsers();
    final exists = users.any((u) => u['phone'] == phone && u['role'] == role);
    if (exists) {
      return 'An account with this phone number already exists.';
    }

    final user = {
      'fullName': fullName,
      'phone': phone,
      'password': password, // NOTE: demo-only; hash before any real launch.
      'role': role,
      'village': village ?? '',
      'district': district ?? '',
      'farmSize': '',
      'primaryCrop': '',
      'avatarPath': '',
    };
    users.add(user);
    await _saveUsers(users);
    await _saveSession(user);
    return null;
  }

  /// Validates credentials and starts a session. Returns an error message,
  /// or null on success.
  static Future<String?> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    final users = await _loadUsers();
    final match = users.where(
      (u) => u['phone'] == phone && u['password'] == password && u['role'] == role,
    );
    if (match.isEmpty) {
      return 'Incorrect phone number or password for this account type.';
    }
    await _saveSession(match.first);
    return null;
  }

  static Future<bool> accountExists({
    required String phone,
    required String role,
  }) async {
    final users = await _loadUsers();
    return users.any((user) => user['phone'] == phone && user['role'] == role);
  }

  static Future<String?> resetPassword({
    required String phone,
    required String role,
    required String newPassword,
  }) async {
    final users = await _loadUsers();
    final index = users.indexWhere(
      (user) => user['phone'] == phone && user['role'] == role,
    );
    if (index == -1) return 'Account not found.';

    final updated = {...users[index], 'password': newPassword};
    users[index] = updated;
    await _saveUsers(users);
    return null;
  }

  // ------------------------------------------------------------
  // SESSION
  // ------------------------------------------------------------

  static Future<void> _saveSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Returns every registered account, optionally filtered by role. Used
  /// by the Admin "Farmer Database" screen. Since this demo has no shared
  /// backend, this only reflects accounts registered on this device.
  static Future<List<Map<String, dynamic>>> getAllUsers({String? role}) async {
    final users = await _loadUsers();
    if (role == null) return users;
    return users.where((u) => u['role'] == role).toList();
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Updates the signed-in user's profile fields, in both the session and
  /// the users table.
  static Future<void> updateProfile(Map<String, dynamic> updates) async {
    final current = await currentUser();
    if (current == null) return;

    final merged = {...current, ...updates};
    await _saveSession(merged);

    final users = await _loadUsers();
    final index = users.indexWhere(
      (u) => u['phone'] == current['phone'] && u['role'] == current['role'],
    );
    if (index != -1) {
      users[index] = merged;
      await _saveUsers(users);
    }
  }

  // ------------------------------------------------------------
  // SCAN HISTORY (crop disease / pest / soil reports)
  // ------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  static Future<void> addHistoryEntry(Map<String, dynamic> entry) async {
    final history = await getHistory();
    history.insert(0, {
      ...entry,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // Keep the most recent 50 entries locally.
    final trimmed = history.take(50).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(trimmed));
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

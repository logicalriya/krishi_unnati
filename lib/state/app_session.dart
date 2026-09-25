import 'package:flutter/material.dart';

import '../services/local_db.dart';


class AppSession extends ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _loaded = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?['role'] == 'admin';
  bool get loaded => _loaded;

  Future<void> load() async {
    final storedUser = await LocalDb.currentUser();
    _user = _sanitizeUserData(storedUser);
    _loaded = true;
    notifyListeners();
  }

  Map<String, dynamic>? _sanitizeUserData(Map<String, dynamic>? rawUser) {
    if (rawUser == null) return null;
    final name = (rawUser['fullName'] ?? '').toString().trim();
    return {
      ...rawUser,
      'fullName': name.isNotEmpty ? name : (rawUser['phone'] ?? 'Farmer'),
    };
  }

  Future<String?> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
    String? village,
    String? district,
  }) async {
    final error = await LocalDb.register(
      fullName: fullName,
      phone: phone,
      password: password,
      role: role,
      village: village,
      district: district,
    );
    if (error == null) {
      _user = await LocalDb.currentUser();
      notifyListeners();
    }
    return error;
  }

  Future<String?> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    final error = await LocalDb.login(phone: phone, password: password, role: role);
    if (error == null) {
      _user = await LocalDb.currentUser();
      notifyListeners();
    }
    return error;
  }

  Future<void> logout() async {
    await LocalDb.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await LocalDb.updateProfile(updates);
    _user = await LocalDb.currentUser();
    notifyListeners();
  }

  static AppSession of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_AppSessionScope>();
    assert(scope != null, 'AppSessionProvider missing above this widget');
    return scope!.notifier!;
  }
}

class AppSessionProvider extends StatefulWidget {
  final Widget child;
  const AppSessionProvider({super.key, required this.child});

  @override
  State<AppSessionProvider> createState() => _AppSessionProviderState();
}

class _AppSessionProviderState extends State<AppSessionProvider> {
  final AppSession _session = AppSession();

  @override
  void initState() {
    super.initState();
    _session.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _session,
      builder: (context, _) {
        return _AppSessionScope(
          notifier: _session,
          child: widget.child,
        );
      },
    );
  }
}

class _AppSessionScope extends InheritedNotifier<AppSession> {
  const _AppSessionScope({required super.notifier, required super.child});
}

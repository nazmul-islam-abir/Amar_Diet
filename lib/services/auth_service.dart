import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the authenticated session for the lifetime of the app.
///
/// Backed by `SharedPreferences` so the user stays logged in across restarts.
class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const _kPhone = 'auth.phone';
  static const _kReferenceNo = 'auth.referenceNo';
  static const _kIsAuthed = 'auth.isAuthed';
  static const _kIsSubscribed = 'auth.isSubscribed';

  String? _phone;
  String? _referenceNo;
  bool _isAuthenticated = false;
  bool _isSubscribed = false;
  bool _hydrated = false;

  String? get phone => _phone;
  String? get referenceNo => _referenceNo;
  bool get isAuthenticated => _isAuthenticated;
  bool get isSubscribed => _isSubscribed;
  bool get isHydrated => _hydrated;

  Future<void> hydrate() async {
    if (_hydrated) return;
    final prefs = await SharedPreferences.getInstance();
    _phone = prefs.getString(_kPhone);
    _referenceNo = prefs.getString(_kReferenceNo);
    _isAuthenticated = prefs.getBool(_kIsAuthed) ?? false;
    _isSubscribed = prefs.getBool(_kIsSubscribed) ?? false;
    _hydrated = true;
    notifyListeners();
  }

  Future<void> setPhone(String phone) async {
    _phone = phone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPhone, phone);
    notifyListeners();
  }

  Future<void> setReferenceNo(String ref) async {
    _referenceNo = ref;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kReferenceNo, ref);
    notifyListeners();
  }

  Future<void> markAuthenticated({bool subscribed = true}) async {
    _isAuthenticated = true;
    _isSubscribed = subscribed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsAuthed, true);
    await prefs.setBool(_kIsSubscribed, subscribed);
    notifyListeners();
  }

  Future<void> markSubscribed(bool value) async {
    _isSubscribed = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsSubscribed, value);
    notifyListeners();
  }

  Future<void> signOut() async {
    _phone = null;
    _referenceNo = null;
    _isAuthenticated = false;
    _isSubscribed = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPhone);
    await prefs.remove(_kReferenceNo);
    await prefs.setBool(_kIsAuthed, false);
    await prefs.setBool(_kIsSubscribed, false);
    notifyListeners();
  }
}

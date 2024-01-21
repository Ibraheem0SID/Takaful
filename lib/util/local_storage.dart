import 'package:data_table_try/data/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs extends ChangeNotifier {
  static SharedPreferences? _sharedPrefs;

  factory Prefs() => Prefs._internal();

  Prefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  setToken(String token) {
    _sharedPrefs?.setString('token', token);
    notifyListeners();
  }

  setUserId(int id) {
    _sharedPrefs?.setInt('user_id', id);
    notifyListeners();
  }

  setUserRole(int role) {
    _sharedPrefs?.setInt('user_role', role);
    notifyListeners();
  }

  deleteLocalStorage() {
    _sharedPrefs?.remove('token');
    _sharedPrefs?.remove('user_id');
    notifyListeners();
  }

  String? get token => _sharedPrefs?.getString('token');

  int? get userId => _sharedPrefs?.getInt('user_id');

  UserRole get userRole {
    int? roleNumber = _sharedPrefs?.getInt('user_role');
    return UserRole.getUserRole(roleNumber);
  }
}

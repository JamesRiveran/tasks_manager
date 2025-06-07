import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../database/DataBaseHelper.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  User? _activeUser;
  bool _isLoading = false;

  List<User> get users => _users;
  User? get activeUser => _activeUser;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();
    _users = await DatabaseHelper.instance.getAllUsers();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setActiveUser(User? user) async {
    _activeUser = user;
    notifyListeners();
  }

  Future<void> addUserToSharedPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userIds = prefs.getStringList('userIds') ?? [];
    if (!userIds.contains(user.id)) {
      userIds.add(user.id);
      await prefs.setStringList('userIds', userIds);
    }
  }
  Future<void> removeUserFromSharedPreferences(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userIds = prefs.getStringList('userIds') ?? [];
    userIds.remove(userId);
    await prefs.setStringList('userIds', userIds);
  }
  
  Future<List<String>> getUserIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userIds') ?? [];
  }

  Future<void> loadUsersFromPrefs() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userIds = prefs.getStringList('userIds') ?? [];
    _users = [];
    for (final id in userIds) {
      final user = await DatabaseHelper.instance.getUserById(id);
      if (user != null) {
        _users.add(user);
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}

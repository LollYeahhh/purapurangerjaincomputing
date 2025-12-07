import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/user_model.dart';

class AuthService {
  /// Dummy users untuk development
  static List<User> _dummyUsers = [
    User(
      nipp: "123456",
      password: "mekanik123",
      role: UserRole.mekanik,
      isFirstLogin: true,
      nama: "Gilang Yanuar",
      photoUrl: null,
    ),
    User(
      nipp: "789012",
      password: "pengawas123",
      role: UserRole.pengawas,
      isFirstLogin: true,
      nama: "Sigit Prabowo",
      photoUrl: null,
    ),
  ];

  // ... rest of the code remains the same

  static Future<User?> login(String nipp, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _dummyUsers.firstWhere(
        (user) => user.nipp == nipp && user.password == password,
      );

      final token =
          'dummy_token_${user.nipp}_${DateTime.now().millisecondsSinceEpoch}';

      return user.copyWith(token: token);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updatePassword(
    String nipp,
    String oldPassword,
    String newPassword,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final userIndex = _dummyUsers.indexWhere((user) => user.nipp == nipp);
    if (userIndex != -1) {
      if (_dummyUsers[userIndex].password == oldPassword) {
        _dummyUsers[userIndex] = _dummyUsers[userIndex].copyWith(
          password: newPassword,
          isFirstLogin: false,
        );
        return true;
      }
    }
    return false;
  }

  static User? getUserByNipp(String nipp) {
    try {
      return _dummyUsers.firstWhere((user) => user.nipp == nipp);
    } catch (e) {
      return null;
    }
  }
}

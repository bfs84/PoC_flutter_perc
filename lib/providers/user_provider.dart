import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../utils/constants.dart'; // 定数をインポート

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  // ログイン処理の例
  Future<void> login(String email, String password) async {
    // API呼び出しの前に疑似的な通信遅延
    await Future.delayed(const Duration(seconds: 2));

    if (email == ADMIN_EMAIL) {
      // 管理者としてログイン
      _user = User(
        userId: 1,
        firstName: ADMIN_NAME, // 管理者用の名前
        lastName: '', // 必要に応じて設定
        email: email,
        role: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      // 通常ユーザーとしてログインする場合の例（必要に応じて修正）
      _user = User(
        userId: 2,
        firstName: 'Guest',
        lastName: '',
        email: email,
        role: 'user',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
} 